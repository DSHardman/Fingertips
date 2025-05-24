plot((A1.temp.times/60), A1.temp.temps, 'linewidth', 2', 'color', 'b');
xlabel("Time (mins)");
ylabel("Temperature (^oC)");
box off
set(gca, 'linewidth', 2, 'fontsize', 15);
set(gcf, 'color', 'w', 'position', [488   502   560   255]);
xlim([0 20.5]);