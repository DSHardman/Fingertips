runstring = "normal"; % Change this to view different datasets

load("Readings/Extracted.mat");

% Plot response vs force of EIT fingertips
names = {"A1"; "A2"; "F1"; "F2"; "G1"; "R1"};
for n = 1:length(names)
    subplot(3,6,n);
    eval(names{n}+"."+runstring+".measvsforce(20);");
    title(names{n});

    subplot(3,6,n+6);
    eval(names{n}+"."+"bent"+".measvsforce(20);");

    subplot(3,6,n+12);
    eval(names{n}+"."+"straight"+".measvsforce(20);");
end


% sgtitle(runstring);
set(gcf, 'color', 'w', 'position', [56         229        1452         536]);

figure();

% Plot response vs force of FSR & pneumatic fingertips
names = {"B1"; "N1"; "Z1"; "H1"; "Q1"};
for n = 1:length(names)
    subplot(3,5,n);
    eval(names{n}+"."+runstring+".measvsforce();");
    title(names{n});

    subplot(3,5,n+5);
    eval(names{n}+"."+"bent"+".measvsforce();");

    subplot(3,5,n+10);
    eval(names{n}+"."+"straight"+".measvsforce();");
end

for i = 1:3
    subplot(3,5,i);
    ylim([-0.1 1.4]);
    subplot(3,5,i+5);
    ylim([-0.1 1.4]);
    subplot(3,5,i+10);
    ylim([-0.1 1.4]);
end

subplot(3,5,4);
ylim([-10 10]);
subplot(3,5,9);
ylim([-10 10]);
subplot(3,5,14);
ylim([-10 10]);

subplot(3,5,5);
ylim([-10e-3 10e-3]);
subplot(3,5,10);
ylim([-10e-3 10e-3]);
subplot(3,5,15);
ylim([-10e-3 10e-3]);

set(gcf, 'color', 'w', 'position', [500   106   808   536]);

% set(gcf, 'color', 'w', 'position', [56         229        1452         536]);