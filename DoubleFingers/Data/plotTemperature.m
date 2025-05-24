load("TemperatureResponse.mat");
% load("B1solderresponse.mat");

clear v
v = VideoWriter('TempResponse');
v.FrameRate = 30;
v.Quality = 100;
open(v);

for i = 1:260
% for i = 1:156:40728
    plot(1.95*[0:i], plotthis(17:17+i, ranking(1:100)), 'linewidth', 2);
    % plot(seconds(times(1:i)-times(1)), 3.3*responses(1:i, :)./1023, 'linewidth', 2);
    set(gcf, 'position', [165 387 1223 388], 'color', 'w');
    box off
    set(gca, 'linewidth', 2, 'fontsize', 15);
    % xlabel("Data Frame");
    xlabel("Time (s)");
    ylabel("Raw Response (V)");
    xlim([1 510]);
    % xlim([0 450]);
    ylim([0.2 0.4]);
    % ylim([1.0 2.2]);
    v.writeVideo(getframe(gcf));
    % if i == 260
    %     break
    % end
    clf;
end

close(v);