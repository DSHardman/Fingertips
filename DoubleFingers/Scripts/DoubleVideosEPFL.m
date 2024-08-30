load("EPFLSignNet.mat");

locations = [21 -189 24;...
            57 -160 24;...
            99 -145 24;...
            139 -121 24];

% Connect to peripherals
clear eitboard printer arduino

printer = serialport("COM12", 250000);
printer.configureTerminator(13);
pause(2);

arduino = serialport("COM10", 9600);


eitboard = serialport("COM6", 9600);
eitboard.Timeout = 25;
pause(1);

eitboard.write("y", "string");
pause(2);

for i = 1:2
    readline(eitboard);
end

printer.writeline('G92 X0 Y0 Z0');
printer.writeline('M211 S0');
printer.writeline("G0 Z50");
pause();

for i = 1:4
    if i > 1
        printer.writeline("G0 Z50");
        printer.writeline("G0 X-58 Y" + string(-(i-2)*37.5));
        pause();
        printer.writeline("G0 Z0");
        printer.writeline("G0 Z50");
    end


    printer.writeline("G0 X" + string(locations(i, 1)) + " Y" + string(locations(i, 2)));
    printer.writeline("G0 Z" + string(locations(i, 3)));
    pause();
    
    
    flush(eitboard);
    readline(eitboard);
    before = str2num(readline(eitboard));
    
    printer.writeline("G0 Z14");
    pause();
    
    flush(eitboard);
    readline(eitboard);
    after = str2num(readline(eitboard));
    response = after - before;
    
    printer.writeline("G0 Z" + string(locations(i, 3)+20));
    
    norminp = normalize(response(ranking(1:800)), 'center', C, 'scale', S);
    
    prediction = predict(net, norminp);
    
    figure();
    viscircles([0, 0], 10, 'color', 'k');
    hold on
    scatter(-prediction(1), -prediction(2), 80, 'r', 'filled');
    set(gca, 'fontsize', 18);
    xlim([-11 11]);
    ylim([-11 11]);
    axis square
    axis off

    save("prediction" + string(i) + ".mat", "prediction", "before", "after");
    
    xpos = locations(i, 1) -93 - prediction(1);
    ypos = locations(i, 2) + 3 - prediction(2);
    printer.writeline("G0 X" + string(xpos) + " Y" + string(ypos));
    pause();
    close();
    printer.writeline("G0 Z-3");
    pause();
    arduino.write("R", "string");
    pause(3);
    arduino.write("O", "string");
    printer.writeline("G0 Z50");
    pause();
    arduino.write("A", "string");
    pause(3);
    arduino.write("O", "string");

    clf
end

clear printer arduino device