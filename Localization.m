savestring = "Localize/A2";
N = 500;
pressdepth = 5;

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
printer.writeline('G92 Z20');
printer.writeline('M211 S0');

% Variables to save
forces = zeros([N, 1]);
locations = zeros([N, 2]);
befores = zeros([N, 1680]);
durings = zeros([N, 1680]);

% Configure boards to EIT measurements
pause(2);
arduino.write("e", "string");
pause(2);
eitboard.write("y", "string");
pause(3);

for i = 1:5
    readline(eitboard);
end

for i = 1:N
    i
    printer.writeline("G0 Z25");

    % Random location within 20mm circle
    while 1
        x = 20*rand()-10;
        y = 20*rand()-10;
        if sqrt(x^2+y^2) <= 10
            break
        end
    end

    % Move to starting position
    printer.writeline("G0 X"+string(x)+" Y"+string(y));
    locations(i, :) = [x y];

    pause(2);

    % Record response before
    flush(eitboard);
    readline(eitboard);
    befores(i, :) = str2num(readline(eitboard));

    % Press
    depthoffset = 12.5 - sqrt(12.5^2-(x^2+y^2));
    printer.writeline("G0 Z"+string(20-depthoffset-pressdepth));

    pause(2);

    % Record pressing force
    flush(arduino);
    readline(arduino);
    arduinodata = str2num(readline(arduino));
    forces(i) = arduinodata(end);

    % Record response after
    flush(eitboard);
    readline(eitboard);
    durings(i, :) = str2num(readline(eitboard));

    save("Readings/"+savestring+".mat", "befores", "durings", "forces", "locations");
end

% Move up and disconnect motors
printer.writeline("G0 Z30");
printer.writeline("M81");

% Disconnect peripherals
clear eitboard printer arduino