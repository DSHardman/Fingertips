names = {"A1"; "A2"; "B1"; "F1"; "F2"; "G1"; "N1"; "P1"; "P2"; "R1"; "T1"; "T2"; "Z1"};

% mylinestyles = ["-"; "--"; "-o"];
% mycolors = 1/255*[166,206,227;...
% 31,120,180;...
% 178,223,138;...
% 51,160,44;...
% 251,154,153;...
% 227,26,28;...
% 253,191,111;...
% 255,127,0;...
% 202,178,214;...
% 106,61,154;...
% 255,255,153;...
% 177,89,40;
% 0,0,0];


% Plot all mechanical measurements
for n = 1:length(names)
    subplot(1,3,1);
    eval(names{n}+".normal.mechplot()");
    % set(gca, 'LineStyleOrder', mylinestyles);
    % set(gca, 'ColorOrder', mycolors);
    hold on
    subplot(1,3,2);
    eval(names{n}+".bent.mechplot()");
    set(gca, 'LineStyleOrder', mylinestyles);
    set(gca, 'ColorOrder', mycolors);
    hold on
    subplot(1,3,3);
    eval(names{n}+".straight.mechplot()");
    set(gca, 'LineStyleOrder', mylinestyles);
    set(gca, 'ColorOrder', mycolors);
    hold on
end

% Add titles
% titles = {"Normal"; "Bent"; "Straight"};
for i = 1:3
    subplot(1,3,i);
    % legend(names, 'orientation', 'horizontal', 'location', 'nw');
    set(gca, 'linewidth', 2, 'fontsize', 15);
    box off
    % title(titles{i});
    % legend boxoff
end

subplot(1,3,1); xlim([0 12]); ylim([0 9]); ylabel("Force (N)");
subplot(1,3,2); xlim([0 12]); ylim([0 3]); xlabel("Displacement (mm)");
subplot(1,3,3); xlim([0 18]); ylim([0 2]);

set(gcf, 'position', [65 463 1438 332], "color", "w");
