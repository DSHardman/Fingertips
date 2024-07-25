runstring = "straight"; % Change this to view different datasets

% Plot forces and heatmap response of EIT fingertips
names = {"A1"; "A2"; "F1"; "F2"; "G1"; "R1"};
for n = 1:length(names)
    eval(names{n}+"."+runstring+".visualise(1, [4, 6, "+string(n)+", "+string(n+6)+"]);");
    subplot(4,6,n);
    title(names{n});
end

% Plot forces and graph response of FSR & pneumatic fingertips
names = {"B1"; "N1"; "Z1"};
for n = 1:length(names)
    eval(names{n}+"."+runstring+".channels([4, 6, "+string(n+12)+", "+string(n+18)+"]);");
    subplot(4,6,n+12);
    title(names{n});
end

set(gcf, 'color', 'w', 'position', [38 283 1490 496]);
sgtitle(runstring);