% init
maximumforce = 2.0; % In N
step = 0.2;

% Connect to peripherals
printer = serialport("COM12", 250000);
printer.configureTerminator(13);
pause(1);
arduino = serialport("COM10", 9600);
pause(1);

% Start from manually placed zero position
printer.writeline('G92 X0 Y0 Z0');
printer.writeline('M211 S0');
pause(1);
arduino.write("r", "string");
pause(4);
arduino.write("o", "string");

% Move to starting position
printer.writeline('G0 Z30');
printer.writeline('G0 Y-20');

pause();

desiredlocations = [37.5 37.5; 3*37.5 75; 0 0]; % Which 3 get used?

for i = 1:3
    % Pick up next fingertip
    printer.writeline("G0 X"+string(desiredlocations(i,1))+...
        " Y"+string(desiredlocations(i,2))+" Z30");
    pause();
    arduino.write("a", "string");
    printer.writeline('G0 Z0');
    pause(2.5);
    arduino.write("o", "string");
    pause(0.5);
    printer.writeline('G0 Z50');

    % Go to normal testing position
    printer.writeline('G0 X75 Y-90');
    printer.writeline("G0 Z-5");

    pause();
    % Start normal force testing
    maximumforce = 6;
    % Press down until maximum force is reached
    force = 0; n = 0;
    while force < maximumforce
        printer.writeline("G0 Z"+string(-5-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    
        if n > 10/step % Do not descend more than 10mm from starting point
            break
        end
    
        if force >= maximumforce
            break
        end
        pause(1);
    
        n = n + 1;
    end

    % Return to starting position
    for j = n:-1:0
        printer.writeline("G0 Z"+string(-5-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    end
    
    fprintf("normal forces ended\n");
    % End normal forces
    pause();

    % Bend and move to bent testing position
    printer.writeline("G0 Z30");
    pause(2);
    arduino.write("b", "string");
    pause(3);
    arduino.write("o", "string");
    printer.writeline('G0 X70 Y-120 Z-48');

    pause();
    % Start bent force testing
    maximumforce = 3;
    % Press down until maximum force is reached
    force = 0; n = 0;
    while force < maximumforce
        printer.writeline("G0 Z"+string(-48-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    
        if n > 10/step % Do not descend more than 10mm from starting point
            break
        end
    
        if force >= maximumforce
            break
        end
        pause(1);
    
        n = n + 1;
    end

    % Return to starting position
    for j = n:-1:0
        printer.writeline("G0 Z"+string(-48-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    end
    
    fprintf("bent forces ended\n");
    % End bent forces
    pause();

    % Straighten and move to testing position
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

    % Start straight forces
    maximumforce = 3;
    % Press down until maximum force is reached
    force = 0; n = 0;
    while force < maximumforce
        printer.writeline("G0 Z"+string(-98-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    
        if n > 15/step % Do not descend more than 15mm from starting point
            break
        end
    
        if force >= maximumforce
            break
        end
        pause(1);
    
        n = n + 1;
    end

    % Return to starting position
    for j = n:-1:0
        printer.writeline("G0 Z"+string(-98-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    end
    
    fprintf("straight forces ended\n");
    % End straight forces
    pause();

    % Move down and to temperature probe
    printer.writeline("G0 Z50");
    pause(10);
    arduino.write("d", "string");
    pause(2);
    arduino.write("o", "string");
    pause(1);
    printer.writeline("G0 X183 Y-42 Z44");
    pause();

    % Start temperature monitoring
    maximumforce = 2;
    force = 0; n = 0;
    % Press down until maximum force is reached
    while force < maximumforce
        printer.writeline("G0 Z"+string(44-n*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    
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

    % Return to starting position
    for j = n:-1:0
        printer.writeline("G0 Z"+string(44-j*step));
        pause(0.5);
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        force = arduinodata(end);
    end
    
    fprintf("temp ended\n");
    % End temp monitoring

    % Return to rack
    printer.writeline("G0 Z50");
    printer.writeline("G0 X"+string(desiredlocations(i,1))+...
        " Y"+string(desiredlocations(i,2)));
    printer.writeline("G0 Z0");
    pause();

    % Release fingertip
    arduino.write("r", "string");
    pause(4);
    arduino.write("o", "string");
    pause(1);
    printer.writeline("G0 Z30");


end

clear printer arduino