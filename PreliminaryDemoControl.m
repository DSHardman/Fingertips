clear device
clear arduino

load("PreliminaryRanking.mat"); % Which EIT board channels should be plotted?

figure();
set(gcf, 'position', [1 48 1536 862]);

arduino = serialport("COM10", 9600);
pause(5);

% Perform basic actuation using N20s

arduino.write("b", "string"); % Bend finger
pause(6);
arduino.write("s", "string"); % Straighten finger
pause(6);
arduino.write("o", "string"); % Turn off H-bridges
pause(1);
arduino.write("r", "string"); % Release fingertip
pause(5);
arduino.write("a", "string"); % Reattach fingertip
pause(5);
arduino.write("o", "string"); % Turn off H-bridges

% Plot raw data signals (using loaded ranking from experimental tests)
device = serialport("COM6", 9600);
device.Timeout = 25;
for i=1:1
    data = readline(device); 
    i
end
plotthis = str2num(data);
for i = 1:30
    data = readline(device);
    if ~isempty(data)
        data = str2num(data);
        plotthis = [plotthis; data];
        plot(plotthis(:, ranking(1:200)), 'linewidth', 2);

        set(gca, 'color', 'w', 'linewidth', 2, 'fontsize', 15);
        set(gcf, 'color', 'w');
        box off
        ylabel("Magnitude");
        ylim([0 1.2]);
        xlim([0 30]);
        drawnow();
    end
end

clf();

arduino.write("r", "string"); % Release fingertip
pause(3);
arduino.write("a", "string"); % Release fingertip
pause(4);
arduino.write("o", "string"); % Release fingertip
pause(3);
clear
close();