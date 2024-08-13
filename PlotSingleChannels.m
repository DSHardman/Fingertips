runstring = "normal"; % Change this to view different datasets
load("Readings/Extracted.mat");

subplot(1,2,1);
names = {"R1"; "A2"; "G1"; "F2"; "F1"; "A1"};
% For legend purposes
for i = 1:length(names)
    eval("col = "+names{i}+".color;")
    plot(nan, nan, 'linewidth', 2, 'color', col);
    hold on
end

% Plot forces and heatmap response of EIT fingertips
for n = 1:length(names)
    eval(names{n}+"."+runstring+".measvsforcefromzero(5);");
    hold on
end
box off
set(gca, 'linewidth', 2, 'fontsize', 15);
% xlim([0 7]);
% ylim([0 0.8]);
legend(names, 'orientation', 'horizontal', 'location', 'n');
legend boxoff


subplot(1,2,2);
names = {"B1"; "N1"; "Z1"};
% For legend purposes
for i = 1:length(names)
    eval("col = "+names{i}+".color;")
    plot(nan, nan, 'linewidth', 2, 'color', col);
    hold on
end

% Plot forces and heatmap response of EIT fingertips
for n = 1:length(names)
    eval(names{n}+"."+runstring+".measvsforcefromzero();");
    hold on
end
box off
set(gca, 'linewidth', 2, 'fontsize', 15);
% xlim([0 7]);
% ylim([0 0.8]);
legend(names, 'orientation', 'horizontal', 'location', 'n');
legend boxoff

set(gcf, 'color', 'w', 'Position', [45 355 1436 420]);