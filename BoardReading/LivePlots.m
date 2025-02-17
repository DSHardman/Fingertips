% For debugging: see EIT board data in real time

clear device
device = serialport("COM20",230400);
device.Timeout = 25;

device.write("y", "string");

for i=1
    data = readline(device); 
    i
end

plotthis = str2num(data);

n = 50;
for i = 1:n
    i
    data = readline(device);
    if ~isempty(data)
        data = str2num(data);
        % plotthis = [plotthis; data];
        % clf
        subplot(2,1,1);
        plot(data(1:length(data)/2));
        subplot(2,1,2);
        plot(fliplr(data(length(data)/2+1:end)));
        % subplot(2,1,2);
        % plot(data(2:2:end));
        % Assumes that ranking variable already exists from a previous script...
        % % plot(plotthis(:, ranking(1:200)), 'linewidth', 2);
        % plot(plotthis, 'linewidth', 2);
        % plot(mean(plotthis(:, 1:100).'));
        % hold on
        % plot(mean(plotthis(:, 101:200).'));
        % 
        % set(gca, 'color', 'w', 'linewidth', 2, 'fontsize', 15);
        % set(gcf, 'color', 'w');
        % box off
        % ylabel("Magnitude");
        % ylim([0 1.2]);
        % xlim([0 n]);
        drawnow();
    end
end

clear device

% heatmap((plotthis-plotthis(1,:)).', "colormap", gray); grid off; %caxis([-10 10])

