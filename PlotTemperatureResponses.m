num_channels = 5;

% EIT changes

subplot(1,3,[1 2]);
names = {"A1"; "A2"; "F1"; "F2"; "R1"};
withtemp = zeros([1, length(names)]);

for i = 1:length(names)
    % names{i}
    [withtemp(i)] = eval(names{i}+".temp.returntempcorrelation();");
end

bar(withtemp);
xticklabels(names);

subplot(1,3,3);
names = {"B1"; "N1"; "Z1"};
withtemp = zeros([1, length(names)]);

for i = 1:length(names)
    % names{i}
    [withtemp(i)] = eval(names{i}+".temp.returntempcorrelation();");
end

bar(withtemp);
xticklabels(names);