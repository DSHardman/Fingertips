names = {"A1"; "A2"; "B1"; "F1"; "F2"; "G1"; "N1"; "P1"; "P2"; "R1"; "T1"; "T2"; "Z1"};

mylinestyles = ["-"; ":"; "-o"];

% Plot all mechanical measurements
for n = 1:length(names)
    subplot(3,1,1);
    eval(names{n}+".normal.mechplot()");
    set(gca, 'LineStyleOrder', mylinestyles);
    hold on
    subplot(3,1,2);
    eval(names{n}+".bent.mechplot()");
    set(gca, 'LineStyleOrder', mylinestyles);
    hold on
    subplot(3,1,3);
    eval(names{n}+".straight.mechplot()");
    set(gca, 'LineStyleOrder', mylinestyles);
    hold on
end

% Add titles
titles = {"Normal"; "Side1"; "Side2"};
for i = 1:3
    subplot(3,1,i);
    legend(names, 'orientation', 'horizontal', 'location', 'nw');
    title(titles{i});
    legend boxoff
end

set(gcf, 'position', [118 58 1274 838], "color", "w");
