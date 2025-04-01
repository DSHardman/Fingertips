load("Readings/Localize/A2.mat");
responses = durings - befores;
% N = 500; % How many channels to input? 500 seems best

testerrors = zeros([100, 5]);

[coeff,~,~,~,~,~] = pca(responses);
[~,ranking] = sort(mean(abs(coeff(:,1)), 2), 'descend');

for i = 1:100
    N = i*10
    for j = 1:5       
        [trainmeans, valmeans, testmeans, errors, pred, target, net] =...
            sensorTrain(responses(:, ranking(1:N)), locations, [100 50 20], [0.8 0.1 0.1], 0);
    testerrors(i, j) = testmeans;
    end
end

%% Part 2: plot
load("LocalizationErrors.mat");

avg_data = mean(testerrors,2,'omitnan').';
std_data = std(testerrors,0,2,'omitnan').';
x = 1:10:1000;

fill([x, flip(x)], [avg_data+std_data, flip(avg_data-std_data)], [0.6 0.6 0.6], 'EdgeColor','none')
hold on
plot(x, smooth(avg_data), 'k', 'linewidth', 2);
plot([0 1000], [6.67 6.67], 'linewidth', 1, 'linestyle', '--', 'color', 'k');

box off
set(gca, 'color', 'w', 'fontsize', 15, 'linewidth', 2);
xlabel("Number of Channels");
ylabel("Localization Error (mm)");

set(gcf, 'color', 'w', 'position', [488   418   560   340]);