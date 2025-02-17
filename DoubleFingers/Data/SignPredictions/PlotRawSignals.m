for i = 1:3
    subplot(3,1,i);
    load("Second/prediction"+string(i+1)+".mat");
    
    plot(after-before, 'linewidth', 2);
    box off
    set(gca, 'fontsize', 15, 'LineWidth', 2);
    xlim([1 1680])
    ylim([-0.4 0.41])
end

set(gcf, 'color', 'w', 'position', [481   238   422   560]);