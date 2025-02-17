load("Data/TapePicking/Second.mat");
rightfinger = plotthis(50:end, 1:100);
leftfinger = plotthis(50:end, 101:200);

xdata = (7/20)*[0:size(leftfinger, 1)-1];

n = size(leftfinger, 1);

% % Comment out these blocks if animation not desired: 1/2
% clear v
% v = VideoWriter('TapePicking');
% v.FrameRate = 2.857;
% v.Quality = 100;
% open(v);
% for n = 2:34

for i = 1:100
    subplot(2,1,1);
    yyaxis left
    plot(xdata(1:n), (leftfinger(1:n, i)-leftfinger(1,i))/leftfinger(1,i),...
        'color', [0.6 0.6 0.6], 'marker', 'none', 'LineStyle', '-');
    hold on
    set(gca, 'yColor', 'k');
    ylim([-1 20]);

    subplot(2,1,2);
    yyaxis left
    plot(xdata(1:n), (rightfinger(1:n, i)-rightfinger(1,i))/rightfinger(1,i),...
        'color', [0.6 0.6 0.6], 'marker', 'none', 'LineStyle', '-');
    hold on
    set(gca, 'yColor', 'k');
    ylim([-1 20]);
    ylabel("                  \DeltaV/V_0");
end


subplot(2,1,1);
yyaxis right
plot(xdata(1:n), mean(leftfinger(1:n, :).'), 'color', 'b', 'LineWidth', 2);
set(gca, 'yColor', 'b', 'fontsize', 15, 'linewidth', 2);
xlim([0 11.56]);
ylim([0.34 0.71]);
box off
title("Left");
set(gca, 'Layer', 'Top');

subplot(2,1,2);
yyaxis right
plot(xdata(1:n), mean(rightfinger(1:n, :).'), 'color', 'b', 'LineWidth', 2);
set(gca, 'yColor', 'b', 'fontsize', 15,  'linewidth', 2);
xlim([0 11.56]);
ylim([0.69 0.77]);
box off
title("Right");
xlabel("Time (s)");
ylabel("                                     Mean Response (V)");
set(gca, 'Layer', 'Top');

set(gcf, 'color', 'w', 'position', [564 316 511 492]);

% % Comment out these blocks if animation not desired: 2/2
% v.writeVideo(getframe(gcf));
% clf
% end
% close(v);