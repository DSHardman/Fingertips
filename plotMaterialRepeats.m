load("Readings/Extracted.mat");
load("Readings/H1_newoutward.mat");
names = {"A1"; "A2"; "B1"; "F1"; "F2"; "G1"; "H1"; "N1"; "P1"; "P2"; "R1"; "T1"; "T2"; "Z1"; "Q1"};

mylinestyles = ["-"; "-"; "--"; "-o"];


% Plot all mechanical measurements
for n = 1:length(names)
    eval(names{n}+".normal.mechplot([0.3 0.3 0.3 0.3], 1)");
    hold on
end

load("Readings/MaterialRepeats.mat");
GA.mechplot(GA.color, 3); GB.mechplot(GB.color, 3);...
    GC.mechplot(GC.color, 3); GD.mechplot(GD.color, 3);

xlim([0 12]);
xlabel("Displacement (mm)");
ylim([0 8]);
ylabel("Force (N)");

set(gca, 'linewidth', 2, 'fontsize', 18);
box off
set(gcf, 'color', 'w');


%% Part 2: Baseline signal
figure();

subplot(4,1,1);
plot(GC.measurements(10, :), 'linewidth', 2, 'color', GC.color);
xlim([0 1680]); box off; ylim([0 1.1]);

subplot(4,1,2);
plot(GD.measurements(10, :), 'linewidth', 2, 'color', GD.color);
xlim([0 1680]); box off; ylim([0 1.1]);

subplot(4,1,3);
plot(GA.measurements(10, :), 'linewidth', 2, 'color', GA.color);
xlim([0 1680]); box off; ylim([0 1.1]);

subplot(4,1,4);
plot(GB.measurements(10, :), 'linewidth', 2, 'color', GB.color);
xlim([0 1680]); box off; ylim([0 1.1]);

set(gcf, 'color', 'w');