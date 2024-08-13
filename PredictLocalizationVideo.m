load("Readings/Localize/A2.mat");
responses = durings - befores;
N = 800; % How many channels to input?

[coeff,~,~,~,~,~] = pca(responses);
[~,ranking] = sort(mean(abs(coeff(:,1)), 2), 'descend');

% Video probes are probes 9 to 18: train from 20 onwards then test on these
[trainmeans, valmeans, testmeans, errors, pred, target, net] =...
    sensorTrain(responses(20:end, ranking(1:N)), locations(20:end, :), [100 50 20], [0.8 0.1 0.1], 1);

%% Part 2
% Normalize test input
[~, C, S] = normalize(responses(20:end, ranking(1:N)));
norminp = normalize(responses(9:18, ranking(1:N)), 'center', C, 'scale', S);

% Make and plot predictions (mirror image is more intuitive)
predictions = predict(net, norminp);
for i = 1:10
    subplot(2,5,i);
    viscircles([0, 0], 10, 'color', 'k');
    hold on
    scatter(-locations(i+8, 1), -locations(i+8, 2), 80, 'b', 'filled');
    scatter(-predictions(i, 1), -predictions(i, 2), 80, 'r', 'filled');
    set(gca, 'fontsize', 18);
    title(string(i));
    xlim([-11 11]);
    ylim([-11 11]);
    axis square
    axis off
end

set(gcf, 'color', 'w', 'position', [122 250 1199 520]);
sgtitle('');