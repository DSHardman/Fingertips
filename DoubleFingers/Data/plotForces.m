% Note saving during experiments repeated a lot of data writing
% This script extracts the responses only once

outputpoints = [65 130 195 260 325 390 455];

for i = 2%1:3
    figure();
    responses = [];
    load("Forces"+string(i)+".mat");
    ind = find(outputpoints <= size(allreadings, 1), 1, "last");
    for j = 1:ind
        responses = [responses; allreadings(outputpoints(j)-9:outputpoints(j), :)];
    end
    heatmap(normalize(responses, "range", [0 1]).', "colormap", gray); grid off
    colorbar off
    Ax = gca;
    Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
end

set(gcf, 'color', 'w', 'Position', [568   489   518   194]);