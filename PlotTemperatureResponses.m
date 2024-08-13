num_channels = 5;

% EIT changes

subplot(1,3,[1 2]);
names = {"A1"; "A2"; "F1"; "F2"; "R1"};
withtemp = zeros([1, length(names)]);
colors = zeros([length(names), 3]);

for i = 1:length(names)
    [withtemp(i)] = eval(names{i}+".temp.returntempcorrelation();");
    colors(i, :) = eval(names{i}+".color;");
end

b = bar(withtemp, 'facecolor', 'flat');
xticklabels(names);
b.CData = colors;
set(gca, 'fontsize', 15);
box off

subplot(1,3,3);
names = {"B1"; "N1"; "Z1"};
withtemp = zeros([1, length(names)]);
colors = zeros([length(names), 3]);

for i = 1:length(names)
    [withtemp(i)] = eval(names{i}+".temp.returntempcorrelation();");
    colors(i, :) = eval(names{i}+".color;");
end

b = bar(withtemp, 'facecolor', 'flat');
xticklabels(names);
b.CData = colors;
set(gca, 'fontsize', 15);
set(gcf, 'color', 'w', 'position', [351 443 968 306]);
box off