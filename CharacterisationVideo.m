% init
maximumforce = 2.0; % In N

% Connect to peripherals
% eitboard = serialport("COM6", 9600);
% eitboard.Timeout = 25;
% pause(1);
printer = serialport("COM12", 250000);
printer.configureTerminator(13);
pause(1);
arduino = serialport("COM10", 9600);
pause(1);

% location = [3 1]; % Need to multiply by 37.5

printer.writeline('G92 X0 Y0 Z0');
printer.writeline('M211 S0');
pause(1);
arduino.write("r", "string");
pause(4);
arduino.write("o", "string");


printer.writeline('G0 Z30');
printer.writeline('G0 Y-20');


% printer.writeline('M301 P1'); % Stop overshoot during low heating

% Start from set position & move to known

pause();

desiredlocations = [37.5 37.5; 3*37.5 75; 0 0];

for i = 1:3
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
    printer.writeline('G0 X75 Y-90');
    printer.writeline("G0 Z-5");

    pause();

    printer.writeline("G0 Z30");
    pause(2);
    arduino.write("b", "string");
    pause(3);
    arduino.write("o", "string");

    printer.writeline('G0 X70 Y-120 Z-48');

    pause();

    printer.writeline('G0 Z30');
    pause(4);
    arduino.write("s", "string");
    pause(4);
    arduino.write("o", "string");
    pause(2);
    arduino.write("u", "string");
    pause(3);
    arduino.write("o", "string");

    printer.writeline("G0 X130 Y-85 Z-95");
    pause();

    printer.writeline("G0 Z50");
    pause(10);
    arduino.write("d", "string");
    pause(2);
    arduino.write("o", "string");
    pause(1);
    printer.writeline("G0 X"+string(desiredlocations(i,1))+...
        " Y"+string(desiredlocations(i,2)));
    printer.writeline("G0 Z0");

    pause();
    arduino.write("r", "string");
    pause(4);
    arduino.write("o", "string");
    pause(1);
    printer.writeline("G0 Z30");

    % Move to normal
    % Perform normal
    
    % Bend & move to bent
    % Peform bent
    
    % Straighten & move to straight
    % Perform straight
    
    % Move to normal & temperature probe
    % Perform temperature oscillation
    
    % Deposit first
    
    % Pick up second
    
    % Move to normal
    % Perform normal
    
    % Bend & move to bent
    % Peform bent
    
    % Straighten & move to straight
    % Perform straight
    
    % Move to normal & temperature probe
    % Perform temperature oscillation

    % Release fingertip

end