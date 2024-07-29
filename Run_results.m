classdef Run_results
    %RUN_RESULTS Stores data from a single fingertip test, or returns NaN

    properties
        forces
        positions
        times
        measurements
        temps
        color
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
                warning("off");
                load(resultspath, "temps");
                obj.temps = temps;
                warning("on");
            catch
                obj.temps = NaN;
            end
        end

        function outres = voltage2res(obj, resistance)
            %VOLTAGE2RES Convert potential divider measurements to
            %resistance
            % Only need to run this once
            outres = resistance*(1023./obj.measurements - 1);
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
                title("Temperatures");
            end
            xlabel("Time (s)");
            set(gcf, 'color', 'w', 'position', [480 108 560 735]);
        end

        function mechplot(obj)
            %MECHPLOT Mechanical response plot
            inds = find(obj.forces>0);
            plot(obj.positions(inds(1):inds(end))-obj.positions(inds(1)),...
                obj.forces(inds(1):inds(end)), 'linewidth', 2, 'Color', obj.color,...
                'LineStyle', '-');
            % xlabel("Z displacement (mm)");
            % ylabel("Force (N)");
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
            ylabel("Reading");
        end

        function measvsforcefromzero(obj, n_ranked)
            %MEASVSFORCEFROMZERO Measurements with applied force, with each
            %channel shown as absolute response from starting point

            % For EIT, can plot only the n_ranked most variable channels
            if nargin == 2
                [coeff,~,~,~,~,~] = pca(obj.measurements);
                [~,ranking] = sort(mean(abs(coeff(:,1)), 2), 'descend');
                plot(obj.forces,...
                    abs(obj.measurements(:, ranking(1:n_ranked))-obj.measurements(1, ranking(1:n_ranked))),...
                    'linewidth', 2, 'color', obj.color);
                ylim([0 1]);
            else
                % Otherwise plot all channels
                plot(obj.forces, obj.measurements-obj.measurements(1,:), 'linewidth', 2, 'color', obj.color);
            end
            xlabel("Force (N)");
            % ylabel("Reading");
        end

        function change = returnmaxchange(obj, n_ranked, max_force)
            %RETURNMAXCHANGE Return average signal change of top ranked channels at max position
            [coeff,~,~,~,~,~] = pca(obj.measurements);
            [~,ranking] = sort(mean(abs(coeff(:,1)), 2), 'descend');

            if nargin == 3 && max(obj.forces) > max_force
                % If a maximum force is defined, only consider ramp up to this
                valid_inds = 1:find(obj.forces>max_force, 1, "first")-1;
            else
                valid_inds = 1:length(obj.positions);
            end

            fpositions = obj.positions(valid_inds);
            fmeasurements = obj.measurements(valid_inds, :);

            change = 0;
            for i = 1:n_ranked
                inds = find(fpositions == max(fpositions));
                change = change +...
                    max(abs(fmeasurements(inds, ranking(i))-fmeasurements(1, ranking(i))));
            end
            change = change/n_ranked;
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

        function measvstemp(obj)
            %MEASVSTEMP Fluctuations with temperature only when stationary
            % i.e. force setting curves are neglected

            inds = find(obj.positions==max(obj.positions));
            plot(obj.temps(inds), obj.measurements(inds, :));

        end
    end
end