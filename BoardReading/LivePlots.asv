% Assumes that ranking variable already exists from a previous script...

clear device
device = serialport("COM6",9600);
device.Timeout = 25;

for i=1:1
    data = readline(device); 
    i
end

plotthis = str2num(data);

for i = 1:60
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
        xlim([0 60]);
        drawnow();
    end
end

