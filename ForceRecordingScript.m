maximumforce = 0.3; % In N: 6 normal, 3 bent, 0.2 human
savestring = "Human/test";
readingtype = "EIT";

% Assume printer has been manually set up and positioned to start at same
% point Z = 30. Z10 is just before touch occurs

% Connect to peripherals
eitboard = serialport("COM6", 9600);
eitboard.Timeout = 25;
pause(1);
printer = serialport("COM12", 250000);
printer.configureTerminator(13);
pause(1);
arduino = serialport("COM10", 9600);
pause(1);

% location = [3 1]; % Need to multiply by 37.5

printer.writeline('G92 Z10');
printer.writeline('M211 S0');

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
pause(2);

force = 0;
forces = [];
positions = [];
times = [];
measurements = [];
n = 0;
step = 0.2; % Move down this many mm each step

pause(1);
printer.write("G0 Z10", "string");
pause(1);
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

    % 10mm for the others
    if n > 15/step % Do not descend more than 10mm from starting point
        break
    end

    if force >= maximumforce
        break
    end
    pause(1);

    n = n + 1;
end

% Optional: hold in place while still recording
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

printer.writeline("G0 Z30");
printer.writeline("M81");

% Save data to file
save("Readings/"+savestring+".mat", "forces", "positions", "times", "measurements");

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

clear eitboard printer arduino