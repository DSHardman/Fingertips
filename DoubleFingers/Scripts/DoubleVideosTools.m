% Connect to peripherals
clear device printer arduino

printer = serialport("COM12", 250000);
printer.configureTerminator(13);
pause(1);

device = serialport("COM6",9600);
device.Timeout = 25;
device.write("y", "string");
data = readline(device); 


arduino = serialport("COM10", 9600);
% pause(3);
% arduino.write("f", "string");
% pause(3);

printer.writeline('G92 X0 Y0 Z0');
printer.writeline('M211 S0');
printer.writeline('G0 Z50');
pause();

printer.writeline('G0 X45 Y-145');
printer.writeline('G0 Z28');
pause();
arduino.write("q", "string");
pause();
arduino.write("o", "string");
printer.writeline('G0 Z50');
printer.writeline('G0 X115');
printer.writeline('G0 Z-7');
pause();
arduino.write("S", "string");
pause();
arduino.write("O", "string");
printer.writeline("G0 Z50");
pause();
arduino.write("s", "string");
pause();
arduino.write("O", "string");
printer.writeline("G0 X0 Y-37.5");
pause();
arduino.write("u", "string");
pause();
arduino.write("O", "string");
printer.writeline("G0 Z0");
pause();
arduino.write("r", "string");
pause();
arduino.write("o", "string");
printer.writeline("G0 Z20");
printer.writeline("G0 Y-75");
printer.writeline("G0 Z0");
printer.writeline("G0 Z50");
pause();
arduino.write("d", "string");
pause();
arduino.write("o", "string");
% printer.writeline("G0 X-60.87 Y-37.5");
printer.writeline("G0 X-70 Y-37.5");
pause();
printer.writeline("G0 Z10");
printer.writeline("G0 X-65");
printer.writeline("G0 Z0");
pause();
arduino.write("R", "string");
pause();
arduino.write("O", "string");
printer.writeline("G0 Z20");
printer.writeline("G0 Y-75");
printer.writeline("G0 Z0");
printer.writeline("G0 Z50"); % second scooper has been picked up
pause();
arduino.write("u", "string");
pause();
arduino.write("o", "string");

printer.writeline("G0 X-8 Y-207");
printer.writeline("G0 Z-11");
printer.writeline("G0 X12");
pause();
arduino.write("d", "string");
pause();
arduino.write("o", "string");
printer.writeline("G0 Z70");

arduino.write("O", "string");
pause(1);
clear printer arduino device