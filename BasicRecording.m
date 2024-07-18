eitboard = serialport("COM6",9600);
eitboard.Timeout = 25;
pause(1);
printer = serialport("COM13",38400);
pause(1);
arduino = serialport("COM10",9600);

readingtype = "EIT";
location = [3 1]; % Need to multiply by 37.5

switch readingtype
    case "EIT"
        arduino.write("e", "string");
        eitboard.write("y", "string");
    case "Pneu"
        eitboard.write("n", "string");
        arduino.write("p", "string");
    case "FSR"
        eitboard.write("n", "string");
        arduino.write("f", "string");
    otherwise
        error("ERROR: Unrecognised Reading Type");
end


% arduino.write("b", "string");


for i=1:1
    data = readline(eitboard); 
    i
end

plotthis = str2num(data);

n = 120;
for i = 1:n
    data = readline(eitboard);
    if ~isempty(data)
        data = str2num(data);
        plotthis = [plotthis; data];
        clf
        plot(plotthis(:, ranking(1:200)), 'linewidth', 2);
        % plot(plotthis, 'linewidth', 2);

        set(gca, 'color', 'w', 'linewidth', 2, 'fontsize', 15);
        set(gcf, 'color', 'w');
        box off
        ylabel("Magnitude");
        % ylim([0 1.2]);
        xlim([0 n]);
        drawnow();
    end
end

clear eitboard

