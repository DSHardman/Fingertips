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
pause(3);
arduino.write("f", "string");
pause(3);

printer.writeline('G92 X0 Y0 Z0');
printer.writeline('M211 S0');

for repetitions = 1:3
    printer.writeline('G0 Z10');
    pause();
    
    allreadings = [];
    fsr = [];

    for i = 1:8
        i
        flush(device);
        readings = zeros([5, 200]);
        for j = 1:10
            data = readline(device);
            readings(j, :) = str2num(data);
            allreadings = [allreadings; readings];
        end
        if max(mean(readings.')) - min(mean(readings.')) < 0.002
            break
        end
        % plot(mean(readings.'));
    end
    
    target = (i-1)*100
    
    printer.writeline('G0 Z0');
    
    calibrations = [10 0; 20 2; 110 5; 156 22; 195 29; 210 29.5; 231 36; 316 52.5; 338 54; 428 65; 451 72; 550 78; 552 88; 638 84; 683 100; 722 102.5; 742 101; 830 105; 1250 119];
    
    vq = interp1(calibrations(:,1), calibrations(:, 2), target);
    
    plotthis = str2num(data);
    n = 300;
    pause();
    fprintf("Starting...\n");
    stepstaken = 0;
    for i = 1:n
        flush(arduino);
        readline(arduino);
        arduinodata = str2num(readline(arduino));
        fsr = [fsr; arduinodata(1)];
        if arduinodata(1) < vq
            stepstaken = stepstaken + 1;
            printer.writeline('G0 Z-'+string(stepstaken*0.05));
            pause(1.0);
        else
            break
        end
    end
    
    pause(5);

    save("forceoutputs"+string(repetitions)+".mat", "allreadings", "fsr");
    printer.writeline('G0 Z10');
end

arduino.write("O", "string");
pause(1);
clear printer arduino device