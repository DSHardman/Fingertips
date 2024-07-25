classdef Fingertip
    %FINGERTIP Collects characterisation results from each individual fingertip

    properties
        normal
        bent
        straight
        temp
        human
    end

    methods
        function obj = Fingertip(code)
            %FINGERTIP Constructor from identifying code
            obj.normal = Run_results("Readings/Normal/"+code+".mat");
            obj.bent = Run_results("Readings/Bent/"+code+".mat");
            obj.straight = Run_results("Readings/Straight/"+code+".mat");
            obj.temp = Run_results("Readings/Temp/"+code+".mat");
            obj.human = Run_results("Readings/Human/"+code+".mat");
        end

        function mechplots(obj)
            % Plot all 3 of the fingertip's mechanical plots
            obj.normal.mechplot();
            hold on
            obj.bent.mechplot();
            obj.straight.mechplot();
            legend({"Normal"; "Bent"; "Straightened"});
        end

    end
end