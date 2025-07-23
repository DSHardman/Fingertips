maximumforce = 6.0; % In N: 6.0 normal, 2.0 bent/straight, 0.2 human
savestring = "Normal/GD";
readingtype = "EIT";

% Printer starts manually positioned just above starting point

% Connect to peripherals
if readingtype == "Cap"
    eitboard = serialport("COM9", 115200);
else
    eitboard = serialport("COM21", 9600);
    eitboard.Timeout = 25;
end
pause(1);
printer = serialport("COM27", 115200);
printer.configureTerminator(13);
pause(2);
arduino = serialport("COM11", 9600);
pause(1);

printer.writeline('G92 Z10');
pause(2);
printer.writeline('M211 S0');
pause(2);

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
    case "Hall"
        % eitboard.write("n", "string");
        pause(2);
        arduino.write("h", "string");
    case "Ben"
        eitboard.write("n", "string");
        pause(2);
        arduino.write("n", "string");
    case "Passive"
        eitboard.write("n", "string");
        pause(2);
        arduino.write("e", "string");
    case "Cap"
        pause(2);
        arduino.write("e", "string");
        pause(2);
    otherwise
        error("ERROR: Unrecognised Reading Type");
end
pause(3);

tic
% Press down until maximum force is reached
while force < maximumforce
    printer.writeline("G0 Z"+string(10-n*step));
    pause(1);
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
    case "Cap"
        flush(eitboard);
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata(1)];
    case "Passive"
        measurements = NaN;
    otherwise
        measurements = [measurements; arduinodata(1:end-1)];
    end

    % Do not descend more than 10mm from starting point
    if n > 10/step  % (Set to 15 for straight tests, 10 for others)
        break
    end

    if force >= maximumforce
        break
    end
    pause(1);

    n = n + 1;
end

% % Optional: hold still while still recording (for human tests)
% % And accidentally left on for some bent repeats
% for i = 1:10
%     pause(0.5);
%     flush(arduino);
%     readline(arduino);
%     arduinodata = str2num(readline(arduino));
%     force = arduinodata(end) % print force in console
%     forces = [forces; force];
%     positions = [positions; n*step];
%     times = [times; toc];
% 
%     switch readingtype
%     case "EIT"
%         flush(eitboard);
%         eitdata = str2num(readline(eitboard));
%         measurements = [measurements; eitdata];
%     case "Cap"
%         flush(eitboard);
%         eitdata = str2num(readline(eitboard));
%         measurements = [measurements; eitdata(1)];
%     case "Passive"
%         measurements = NaN;
%     otherwise
%         measurements = [measurements; arduinodata(1:end-1)];
%     end
% end

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
    case "Cap"
        flush(eitboard);
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata(1)];
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