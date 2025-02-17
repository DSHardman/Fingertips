load("TemperatureResponse.mat");

clear v
v = VideoWriter('TempResponse');
v.FrameRate = 30;
v.Quality = 100;
open(v);

for i = 1:260
    plot(plotthis(17:17+i, ranking(1:100)), 'linewidth', 2);
    set(gcf, 'position', [165 387 1223 388], 'color', 'w');
    box off
    set(gca, 'linewidth', 2, 'fontsize', 15);
    xlabel("Data Frame");
    ylabel("Raw Response (V)");
    xlim([1 261]);
    ylim([0.2 0.4]);
    v.writeVideo(getframe(gcf));
    clf;
end

close(v);