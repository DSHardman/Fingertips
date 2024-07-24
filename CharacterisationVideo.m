% init
maximumforce = 2.0; % In N
step = 0.2;

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
    % start normal forces
    maximumforce = 6;
    % Press down until maximum force is reached
    force = 0; n = 0;
    while force < maximumforce
        printer.writeline("G0 Z"+string(-5-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    
        % 10mm for the others
        if n > 10/step % Do not descend more than 10mm from starting point
            break
        end
    
        if force >= maximumforce
            break
        end
        pause(1);
    
        n = n + 1;
    end

    for j = n:-1:0
        printer.writeline("G0 Z"+string(-5-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    end
    
    fprintf("normal forces ended\n");
    % end normal forces
    pause();


    printer.writeline("G0 Z30");
    pause(2);
    arduino.write("b", "string");
    pause(3);
    arduino.write("o", "string");

    printer.writeline('G0 X70 Y-120 Z-48');

    pause();
    % start bent forces
    maximumforce = 3;
    % Press down until maximum force is reached
    force = 0; n = 0;
    while force < maximumforce
        printer.writeline("G0 Z"+string(-48-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    
        % 10mm for the others
        if n > 10/step % Do not descend more than 10mm from starting point
            break
        end
    
        if force >= maximumforce
            break
        end
        pause(1);
    
        n = n + 1;
    end

    for j = n:-1:0
        printer.writeline("G0 Z"+string(-48-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    end
    
    fprintf("bent forces ended\n");
    % end bent forces
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

    printer.writeline("G0 X130 Y-85 Z-98");
    pause();

    % start straight forces
    maximumforce = 3;
    % Press down until maximum force is reached
    force = 0; n = 0;
    while force < maximumforce
        printer.writeline("G0 Z"+string(-98-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    
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

    for j = n:-1:0
        printer.writeline("G0 Z"+string(-98-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    end
    
    fprintf("straight forces ended\n");
    % end straight forces
    pause();

    printer.writeline("G0 Z50");
    pause(10);
    arduino.write("d", "string");
    pause(2);
    arduino.write("o", "string");
    pause(1);
    
    printer.writeline("G0 X183 Y-42 Z44");
    pause();
    % start temp monitoring
    maximumforce = 2;
    force = 0; n = 0;
    % Press down until maximum force is reached
    while force < maximumforce
        printer.writeline("G0 Z"+string(44-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    
        % 10mm for the others
        if n > 10/step % Do not descend more than 10mm from starting point
            break
        end
    
        if force >= maximumforce
            break
        end
        pause(1);
    
        n = n + 1;
    end

    pause(60); % Wait one minute before proceeding

    for j = n:-1:0
        printer.writeline("G0 Z"+string(44-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end); % print force in console
    end
    
    fprintf("temp ended\n");
    % end temp monitoring


    printer.writeline("G0 Z50");

    printer.writeline("G0 X"+string(desiredlocations(i,1))+...
        " Y"+string(desiredlocations(i,2)));
    printer.writeline("G0 Z0");

    pause();
    arduino.write("r", "string");
    pause(4);
    arduino.write("o", "string");
    pause(1);
    printer.writeline("G0 Z30");


end

clear printer arduino