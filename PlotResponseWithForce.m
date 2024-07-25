runstring = "bent"; % Change this to view different datasets

% Plot response vs force of EIT fingertips
names = {"A1"; "A2"; "F1"; "F2"; "G1"; "R1"};
for n = 1:length(names)
    subplot(2,6,n);
    eval(names{n}+"."+runstring+".measvsforce(20);");
    title(names{n});
end

% Plot response vs force of FSR & pneumatic fingertips
names = {"B1"; "N1"; "Z1"};
for n = 1:length(names)
    subplot(2,6,n+6);
    eval(names{n}+"."+runstring+".measvsforce();");
    title(names{n});
end

sgtitle(runstring);
set(gcf, 'color', 'w', 'position', [55 430 1451 334]);