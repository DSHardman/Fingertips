classdef Run_results
    %RUN_RESULTS Stores data from a single fingertip test, or returns NaN

    properties
        forces
        positions
        times
        measurements
        temps
    end

    methods
        function obj = Run_results(resultspath)
            %RUN_RESULTS constructor: load results from path, or return NaN
            try
                load(resultspath, "forces", "positions", "times", "measurements");
                obj.forces = forces;
                obj.positions = positions;
                obj.times = times;
                obj.measurements = measurements;
            catch
                fprintf("Couldn't load results, returning NaN: "+resultspath+"\n");
                obj.forces = NaN;
                obj.positions = NaN;
                obj.times = NaN;
                obj.measurements = NaN;
            end

            % Temperatures treated separately for passive fingertips
            try
                obj.temps = temps;
            catch
                obj.temps = NaN;
            end
        end

        function plotall(obj)
            %PLOTALL with time
            subplot(4,1,1);
            plot(obj.times, obj.positions);
            xlim([0 obj.times(end)]);
            title("Positions");
            subplot(4,1,2);
            plot(obj.times, obj.forces);
            xlim([0 obj.times(end)]);
            title("Forces");
            subplot(4,1,3);
            plot(obj.times, obj.measurements);
            xlim([0 obj.times(end)]);
            title("Measurements");
            if ~isnan(obj.temps)
                subplot(4,1,4);
                plot(obj.times, obj.temps);
                xlim([0 obj.times(end)]);
            end
            xlabel("Time (s)");
            set(gcf, 'color', 'w', 'position', [480 108 560 735]);
        end

        function mechplot(obj)
            %MECHPLOT Mechanical response plot
            plot(obj.positions, obj.forces);
            xlabel("Z displacement (mm)");
            ylabel("Force (N)");
        end

        function measvsforce(obj, n_ranked)
            %MEASVSFORCE Measurements with applied force

            % For EIT, can plot only the n_ranked most variable channels
            if nargin == 2
                [coeff,~,~,~,~,~] = pca(obj.measurements);
                [~,ranking] = sort(mean(abs(coeff(:,1)), 2), 'descend');
                plot(obj.forces, obj.measurements(:, ranking(1:n_ranked)));
                ylim([0 1]);
            else
                % Otherwise plot all channels
                plot(obj.forces, obj.measurements);
            end
            xlabel("Force (N)");
            ylabel("Measurements");
        end

        function visualise(obj, ranked, subplotoverride)
            %VISUALISE Plot normalised heatmap

            % ranked flag sorts channel order in heatmap
            % subplotoverride allows position to be defined
            if nargin == 1
                ranked = 0;
                subplotoverride = 0;
            end
            if nargin == 2
                subplotoverride = 0;
            end

            % Set location 1
            if subplotoverride
                subplot(subplotoverride(1), subplotoverride(2), subplotoverride(3));
            else
                subplot(2,1,1);
            end

            % Plot forces at top
            plot(obj.forces);
            xlim([0 length(obj.forces)]);

            % Set location 2
            if subplotoverride
                subplot(subplotoverride(1), subplotoverride(2), subplotoverride(4));
            else
                subplot(2,1,2);
            end
            
            % Plot heatmap below
            if ranked
                [coeff,~,~,~,~,~] = pca(obj.measurements);
                [~,ranking] = sort(mean(abs(coeff(:,1)), 2), 'descend');
                heatmap(normalize(obj.measurements(:, ranking), "range", [0 1]).', "colormap", gray); grid off
            else
                heatmap(normalize(obj.measurements, "range", [0 1]).', "colormap", gray); grid off
            end

            Ax = gca;
            Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
            Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
        end

        function channels(obj, subplotoverride)
            %CHANNELS Equivalent of visualise for discrete channels
            % i.e. graph rather than heatmap
            if nargin == 1
                subplotoverride = 0;
            end

            if subplotoverride
                subplot(subplotoverride(1), subplotoverride(2), subplotoverride(3));
            else
                subplot(2,1,1);
            end
            plot(obj.forces);
            xlim([0 length(obj.forces)]);

            if subplotoverride
                subplot(subplotoverride(1), subplotoverride(2), subplotoverride(4));
            else
                subplot(2,1,2);
            end
            
            plot(obj.measurements);
        end
    end
end