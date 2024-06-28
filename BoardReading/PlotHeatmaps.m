clear device
device = serialport("COM6",11520);

expecteddatalength = 1680;

data = readline(device);

allreadings = [];
fprintf("Starting...\n")
tic
while toc < 30 %66
    data = readline(device);
    data = str2num(data);

    if length(data) == expecteddatalength
        allreadings = [allreadings; data]; % check orientation
    end
end

[coeff,score,latent,tsquared,explained, mu] = pca(allreadings);
[~,ranking] = sort(abs(mean(coeff(:,1), 2)), 'descend');
heatmap(normalize(allreadings(:, ranking), "range", [0 1]).', "colormap", gray); grid off

%clear all