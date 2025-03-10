num_channels = 5;

% EIT changes

% subplot(1,3,[1 2]);
% names = {"A1"; "A2"; "F1"; "F2"; "R1"; "B1"; "N1"; "Z1"};
names = {"Q1"; "H1"; "R1"; "Z1"; "A2"; "F2"; "A1"; "F1"; "N1"; "B1"};
withtemp = zeros([1, length(names)]);
colors = zeros([length(names), 3]);

for i = 1:length(names)
    correlation = eval(names{i}+".temp.returntempcorrelation();");
    % colors(i, :) = eval(names{i}+".color;");
    for j = 1:length(correlation)
        if isnan(correlation(j))
            correlation(j) = 0;
        end
    end
    col = eval(names{i}+".color;");
    b = bar(i, max(correlation), 'Linewidth', 2, 'FaceColor', col);
    % b.CData = eval(names{i}+".color;");
    hold on
    line([i-0.4 i+0.4], [mean(correlation), mean(correlation)],...
        'color', 'k', 'linewidth', 2, 'linestyle', ":");
end

ylabel("Normalized Signal Correlation");
set(gca, 'fontsize', 15, 'linewidth', 2);
set(gca, 'XTickLabel',[]);
box off

set(gcf, 'color', 'w', 'position', [312   350   738   343]);