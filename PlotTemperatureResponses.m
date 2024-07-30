num_channels = 5;

% EIT changes
subplot(1,3,[1 2]);
names = {"R1"; "A1"; "A2"; "F1"; "F2"; "G1"};
withtemp = zeros([1, length(names)]);
withouttemp = zeros([1, length(names)]);

for i = 1:length(names)
    [withtemp(i), boundaryforces] = eval(names{i}+".temp.returnchangefromtemp("+string(num_channels)+");");
    withouttemp(i) = eval(names{i}+".normal.returnmaxchange("+string(num_channels)+", "+string(boundaryforces(1))+");")-...
        eval(names{i}+".normal.returnmaxchange("+string(num_channels)+", "+string(boundaryforces(2))+");");
end

b = bar([withouttemp; withtemp].');
b(1).FaceColor = [0.3 0.3 0.3];
b(2).FaceColor = 1/255*[251 128 114];
set(gca, "Fontsize", 13, "LineWidth", 2);
box off
xticklabels(names);
legend({"Insulated Surface"; "Human Contact"}, 'location', 'nw');
legend boxoff
ylabel("\DeltaV @ 0.2N");
title("AC Sensors");

% % Resistance changes
% subplot(1,3,3);
% b = bar((5/1023)*[B1.normal.returnmaxchange(2, 0.2), B1.human.returnmaxchange(2, 0.2);...
%     N1.normal.returnmaxchange(1, 0.2), N1.human.returnmaxchange(1, 0.2);...
%     Z1.normal.returnmaxchange(2, 0.2), Z1.human.returnmaxchange(2, 0.2)]);
% 
% b(1).FaceColor = [0.3 0.3 0.3];
% b(2).FaceColor = 1/255*[251 128 114];
% set(gca, "Fontsize", 13, "LineWidth", 2);
% box off
% xticklabels({"B1"; "N1"; "Z1"});
% ylabel("\DeltaV @ 0.2N");
% title("DC Sensors");


set(gcf, 'color', 'w', 'Position', [233 468 1044 290]);