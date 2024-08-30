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
pause(1);

printer.writeline('G92 X0 Y0 Z0');
printer.writeline('M211 S0');

printer.writeline('G0 Z50');
pause();
printer.writeline('G0 Z0');
pause();

plotthis = str2num(data);
n = 300;
fprintf("Starting...\n");
for i = 1:n
    data = readline(device);
    if ~isempty(data)
        data = str2num(data);
        plotthis = [plotthis; data];

        if mean(plotthis(i+1, 1:100)) - mean(plotthis(i, 1:100)) > 0.006
            detect1 = 1;
        else
            detect1 = 0;
        end

        if mean(plotthis(i+1, 101:200)) - mean(plotthis(i, 101:200)) > 0.01
            detect2 = 1;
        else
            detect2 = 0;
        end

        if detect1 && detect2
            arduino.write("b", "string");
            pause(0.4);
            arduino.write("B", "string");
            pause(0.7);
            arduino.write("O", "string");
            data = readline(device);
            data = str2num(data);
            plotthis = [plotthis; data];
            pause(2);
            data = readline(device);
            data = str2num(data);
            plotthis = [plotthis; data];
            printer.writeline('G0 Z50');
            for j = 1:3
                data = readline(device);
                data = str2num(data);
                plotthis = [plotthis; data];
            end
            break
        elseif detect1
            printer.writeline('G92 X0');
            printer.writeline('G0 X-10');
            pause(1);
        elseif detect2
            printer.writeline('G92 X0');
            printer.writeline('G0 X10');
            pause(1);
        end
    end
end


arduino.write("O", "string");
pause(1);
clear printer arduino device