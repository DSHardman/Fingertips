%% Part 1: Hall Effect
figure();

load("ExtractedHallEffect.mat");

my_colors

clear v
v = VideoWriter('HallEffect');
v.FrameRate = 30;
v.Quality = 100;
open(v);

for frame = 2:size(data, 1)
    subplot(2,1,1);
    line([0 1000], [0 0], 'linewidth', 2, 'color', 'k');
    hold on
    for i = 1:3
        plot(data(1:frame, i), 'color', colors(i, :), 'linewidth', 2);
    end
    set(gca, 'linewidth', 2, 'fontsize', 15);
    box off
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1]);
    ylim([-40 10]);
    xlim([0 1000]);
    ylabel("Magnetic Field (mT)");
    
    subplot(2,1,2);
    line([0 1000], [0 0], 'linewidth', 2, 'color', 'k');
    hold on
    plot(data(1:frame, 4), 'color', 'b', 'linewidth', 2);
    set(gca, 'linewidth', 2, 'fontsize', 15);
    box off
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1]);
    ylim([-1 11]);
    xlim([0 1000]);
    ylabel("Force (N)");
    
    set(gcf, 'color', 'w', 'position', [488 222 716 536]);
    v.writeVideo(getframe(gcf));
end

close(v);

%% Part 2: Pneumatic
figure();
load("ExtractedPneumatic.mat");

clear v
v = VideoWriter('Pneumatic');
v.FrameRate = 30;
v.Quality = 100;
open(v);

for frame = 2:size(data, 1)
    subplot(2,1,1);
    line([0 1000], [0 0], 'linewidth', 2, 'color', 'k');
    hold on
    plot(5*data(1:frame, 1)./255, 'color', colors(1, :), 'linewidth', 2);
    set(gca, 'linewidth', 2, 'fontsize', 15);
    box off
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1]);
    ylim([-40 10]);
    xlim([0 1000]);
    ylabel("Voltage (V)");
    
    subplot(2,1,2);
    line([0 1000], [0 0], 'linewidth', 2, 'color', 'k');
    hold on
    plot(data(1:frame, 4), 'color', 'b', 'linewidth', 2);
    set(gca, 'linewidth', 2, 'fontsize', 15);
    box off
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1]);
    ylim([-1 11]);
    xlim([0 1000]);
    ylabel("Force (N)");
    
    set(gcf, 'color', 'w', 'position', [488 222 716 536]);
    v.writeVideo(getframe(gcf));
end

close(v);

%% Part 3: Gelatin
figure();
load("ExtractedGelatin.mat");

clear v
v = VideoWriter('Gelatin');
v.FrameRate = 1;
v.Quality = 100;
open(v);

for frame = 2:size(data, 1)
    plot(data(1:frame, :));
    set(gca, 'linewidth', 2, 'fontsize', 15);
    box off
    set(gca,'xtick',[]);
    ylim([0 1.1]);
    xlim([0 65]);
    ylabel("Voltage (V)");
    
    set(gcf, 'color', 'w', 'position', [488 222 716 536]);
    v.writeVideo(getframe(gcf));
end

close(v);