% Response magnitudes at 0.2N - insulated surface and touching human finger

max_force = 0.2;

% EIT changes
% subplot(1,3,[1 2]);
% names = {"R1"; "A1"; "A2"; "F1"; "F2"; "G1"; "B1"; "Z1"; "N1"};
names = {"Z1"; "N1"; "B1"; "R1"; "G1"; "F1"; "F2"; "A1"; "A2"};
% insulated = zeros([1, length(names)]);
% touched = zeros([1, length(names)]);

for i = 1:length(names)
    insulated = eval(names{i}+".normal.returnmaxchange("+string(max_force)+");");
    touched = eval(names{i}+".human.returnmaxchange("+string(max_force)+");");
    if length(touched) < 5
        insulated = (5/1023)*insulated;
        touched = (5/1023)*touched;
    end
    col = eval(names{i}+".color");
    b = bar(i, [max(insulated) max(touched)], 1.0, 'LineWidth', 2);
    b(1).FaceColor = [0.3 0.3 0.3];
    b(2).FaceColor = col;
    hold on
    line([i i+0.3], [mean(touched) mean(touched)],...
        'color', 'k', 'linewidth', 2, 'linestyle', ":");
end

box off
% legend({"Insulated Surface"; "Human Contact"}, 'location', 'nw');
% legend boxoff
ylabel("\DeltaV at 0.2N");
set(gca, 'fontsize', 15, 'linewidth', 2);
set(gca, 'XTickLabel',[]);

set(gcf, 'color', 'w', 'position', [428   377   735   372]);