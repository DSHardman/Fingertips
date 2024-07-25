maximumforce = 0.2; % In N: 6.0 normal, 3.0 bent/straight, 0.2 human
savestring = "Human/B1";
readingtype = "Ben";

% Printer starts manually positioned just above starting point

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

% Variables to save
force = 0;
forces = [];
positions = [];
times = [];
measurements = [];
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
    case "Ben"
        eitboard.write("n", "string");
        pause(2);
        arduino.write("n", "string");
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
    force = arduinodata(end) % print force in console
    forces = [forces; force];
    positions = [positions; n*step];
    times = [times; toc];

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

    % Do not descend more than 10mm from starting point
    if n > 15/step  % (Set to 15 for straight tests)
        break
    end

    if force >= maximumforce
        break
    end
    pause(1);

    n = n + 1;
end

% Optional: hold still while still recording (for human tests)
for i = 1:10
    pause(0.5);
    flush(arduino);
    readline(arduino);
    arduinodata = str2num(readline(arduino));
    force = arduinodata(end) % print force in console
    forces = [forces; force];
    positions = [positions; n*step];
    times = [times; toc];

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
    force = arduinodata(end) % print force in console
    forces = [forces; force];
    positions = [positions; i*step];
    times = [times; toc];

    % Update measurements
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
save("Readings/"+savestring+".mat", "forces", "positions", "times", "measurements");

% Plot results
plot(forces)
subplot(3,1,1);
plot(positions);
title("Positions");
subplot(3,1,2);
plot(forces);
title("Forces");
subplot(3,1,3);
plot(measurements);
title("Measurements");
set(gcf, 'color', 'w', 'position', [480   108   560   735]);

% Disconnect peripherals
clear eitboard printer arduino