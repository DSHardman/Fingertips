maximumforce = 2.0; % In N
savestring = "Temp/G1";
readingtype = "EIT";

% Printer starts manually positioned just above temperature probe
% Creality fan is pointed at probe throughout for sufficient cooling

% Connect to peripherals
eitboard = serialport("COM6", 9600);
eitboard.Timeout = 25;
pause(1);
printer = serialport("COM12", 250000);
printer.configureTerminator(13);
pause(1);
arduino = serialport("COM10", 9600);
pause(1);
printer.writeline('G92 Z10');
printer.writeline('M211 S0');
printer.writeline('M301 P1'); % PID parameter - attempt to stop overshoot

% Variables to save
force = 0;
forces = [];
positions = [];
times = [];
measurements = [];
temps = [];
n = 0;
step = 0.2; % Move down this many mm each step

% Configure boards to fingertip type
switch readingtype
    case "EIT"
        pause(2);
        arduino.write("e", "string");
        pause(2);
        eitboard.write("y", "string");
        pause(2);
    case "Pneu"
        eitboard.write("n", "string");
        pause(2);
        arduino.write("p", "string");
    case "FSR"
        eitboard.write("n", "string");
        pause(2);
        arduino.write("f", "string");
    case "Passive"
        eitboard.write("n", "string");
        pause(2);
        arduino.write("e", "string");
    otherwise
        error("ERROR: Unrecognised Reading Type");
end

pause(3);
tic

% Press down until maximum force is reached
while force < maximumforce
    printer.writeline("G0 Z"+string(10-n*step));
    pause(0.5);
    flush(arduino);
    readline(arduino);
    arduinodata = str2num(readline(arduino));
    force = arduinodata(end)
    forces = [forces; force];
    temp = gettemperature(printer);
    temps = [temps; temp];
    positions = [positions; n*step];
    times = [times; toc];

    % Update measurements
    switch readingtype
    case "EIT"
        flush(eitboard);
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata];
    case "Passive"
        measurements = NaN;
    otherwise
        measurements = [measurements; arduinodata(1:end-1)];
    end

    if n > 15/step % Do not descend more than 15mm from starting point
        break
    end

    if force >= maximumforce
        break
    end
    pause(1);

    n = n + 1;
end

printer.writeline('M104 S35'); % Set target temp to 35 for 8 seconds
fprintf("Heating...\n");
t0 = toc;
while toc - t0 < 8
    pause(0.5);
    flush(arduino);
    readline(arduino);
    arduinodata = str2num(readline(arduino));

    force = arduinodata(end);
    forces = [forces; force];
    temp = gettemperature(printer) % Print temperature in console
    temps = [temps; temp];
    positions = [positions; n*step];
    times = [times; toc];
    toc - t0 % Print time in console

    % Update measurements
    switch readingtype
    case "EIT"
        flush(eitboard);
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata];
    case "Passive"
        measurements = NaN;
    otherwise
        measurements = [measurements; arduinodata(1:end-1)];
    end
end

printer.writeline('M104 S0'); % Cooldown
fprintf("Cooling...\n")

% Hold in place for 5 minutes
t0 = toc;
while toc -t0 < 300
    pause(0.5);
    flush(arduino);
    readline(arduino);
    arduinodata = str2num(readline(arduino));
    force = arduinodata(end);
    forces = [forces; force];
    temp = gettemperature(printer) % Print temperature in console
    temps = [temps; temp];
    positions = [positions; n*step];
    times = [times; toc];
    toc - t0 % Print time in console

    % Update measurements
    switch readingtype
    case "EIT"
        flush(eitboard);
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata];
    case "Passive"
        measurements = NaN;
    otherwise
        measurements = [measurements; arduinodata(1:end-1)];
    end
end


% Return to starting position whilst still measuring
for i = n:-1:0
    printer.writeline("G0 Z"+string(10-i*step));
    pause(0.5);
    flush(arduino);
    readline(arduino);
    arduinodata = str2num(readline(arduino));
    force = arduinodata(end)
    forces = [forces; force];
    temp = gettemperature(printer);
    temps = [temps; temp];
    positions = [positions; i*step];
    times = [times; toc];

    switch readingtype
    case "EIT"
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata];
    case "Passive"
        measurements = NaN;
    otherwise
        measurements = [measurements; arduinodata(1:end-1)];
    end
    pause(1);
end

% Move up and disconnect motors
printer.writeline("G0 Z30");
printer.writeline("M81");

% Save data to file
save("Readings/"+savestring+".mat", "forces", "positions", "times", "measurements", "temps");

% Plot results
subplot(3,1,1);
plot(temps);
title("Temperatures");
subplot(3,1,2);
plot(forces);
title("Forces");
subplot(3,1,3);
plot(measurements);
title("Measurements");
set(gcf, 'color', 'w', 'position', [480   108   560   735]);

% Disconnect from peripherals
clear eitboard printer arduino

% Request & parse temperature data through Marlin
function temp = gettemperature(printer)
        flush(printer);
    printer.writeline('M105');
    printer.configureTerminator("LF");
    temp = printer.readline();
    temp = char(temp);
    if temp(4) ~= 'T'
        temp = printer.readline();
        temp = char(temp);
    end
    printer.configureTerminator(13);
    temp = str2double(temp(6:10));
end