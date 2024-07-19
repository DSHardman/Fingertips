maximumforce = 6.0; % In N
savestring = "Normal/test";

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

readingtype = "Pneu";
% location = [3 1]; % Need to multiply by 37.5

printer.writeline('G92 Z0');

switch readingtype
    case "EIT"
        arduino.write("e", "string");
        eitboard.write("y", "string");
    case "Pneu"
        eitboard.write("n", "string");
        pause(2);
        arduino.write("p", "string");
    case "FSR"
        eitboard.write("n", "string");
        arduino.write("f", "string");
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
step = 0.5; % Move down this many mm each step

pause(1);
printer.write("G0 Z10", "string");
pause(1);
tic

% Press down until maximum force is reached
while force < maximumforce
    printer.writeline("G0 Z"+string(10-n*step));
    flush(arduino);
    readline(arduino);
    arduinodata = str2num(readline(arduino));
    force = arduinodata(end);
    forces = [forces; force];
    positions = [positions; n*step];
    times = [times; toc];
    n = n + 1;

    switch readingtype
    case "EIT"
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata];
    otherwise
        measurements = [measurements; arduinodata(1:end-1)];
    end

    if n > 10/step % Do not descend more than 10mm from starting point
        break
    end
    pause(1);
end

% Return to starting position whilst still measuring
for i = n:-1:0
    printer.writeline("G0 Z"+string(10-i*step));
    arduinodata = str2num(readline(arduino));
    force = arduinodata(end);
    forces = [forces; force];
    positions = [positions; n*step];
    times = [times; toc];

    switch readingtype
    case "EIT"
        eitdata = str2num(readline(eitboard));
        measurements = [measurements; eitdata];
    otherwise
        measurements = [measurements; arduinodata(1:end-1)];
    end
    pause(1);
end

printer.writeline("M81");

% Save data to file
save("Readings/"+savestring+".mat", "forces", "positions", "times", "measurements");

clear eitboard printer arduino