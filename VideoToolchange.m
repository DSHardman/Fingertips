
% Connect to peripherals
printer = serialport("COM12", 250000);
printer.configureTerminator(13);
pause(1);
arduino = serialport("COM10", 9600);
pause(1);

printer.writeline('G92 X0 Y0 Z0');
printer.writeline('M211 S0');
pause(1);
arduino.write("r", "string");
pause(2.5);
arduino.write("o", "string");


printer.writeline('G0 Z30');
printer.writeline('G0 Y-20');

pause();

desiredlocations = [0 0; 37.5 0; 75 0; 3*37.5 0; 150 0];

for i = 1:5
    % pick up next
    printer.writeline("G0 X"+string(desiredlocations(i,1))+...
        " Y"+string(desiredlocations(i,2))+" Z30");
    pause();
    arduino.write("a", "string");
    printer.writeline('G0 Z0');
    pause(2.5);
    arduino.write("o", "string");
    pause(0.5);
    printer.writeline('G0 Z50');

    pause();
    arduino.write("b", "string");
    pause(3);
    arduino.write("s", "string");
    pause(2);
    arduino.write("o", "string");

    printer.writeline("G0 Z0");

    pause();
    arduino.write("r", "string");
    pause(2.5);
    arduino.write("o", "string");
    pause(1);
    printer.writeline("G0 Z30");


end

clear printer arduino