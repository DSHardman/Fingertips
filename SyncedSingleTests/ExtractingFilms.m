% lines = readlines("HallEffectFilmed.txt");
% data = zeros(length(lines), 4);

% lines = readlines("PneumaticFilmed.txt");
% data = zeros(length(lines), 2);

lines = readlines("GelatinFilmed.txt");
data = zeros(length(lines), 1680);

for i = 1:length(lines)
    line = char(lines(i));
    brief = str2double(split(line, ", "));
    data(i, :) = brief(1:1680).';
    % data(i, :) = [brief(1) brief(2) brief(3) brief(4)];
    % data(i, :) = [brief(1) brief(2)];
end