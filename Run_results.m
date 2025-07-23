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

        function plotall(obj, tempchangeonly)
            %PLOTALL with time

            % For temp measurements, don't include force ramps
            if nargin == 2 && tempchangeonly
                inds = find(obj.positions == max(obj.positions));
                obj.times = obj.times(inds) - obj.times(inds(1));
                obj.positions = obj.positions(inds);
                obj.temps = obj.temps(inds);
                obj.forces = obj.forces(inds);
                obj.measurements = obj.measurements(inds, :);
            end

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

        function mechplot(obj, col, width)
            %MECHPLOT Mechanical response plot
            if nargin == 1
                col = obj.color;
                width = 2;
            end
            inds = find(obj.forces>0);
            plot(obj.positions(inds(1):inds(end))-obj.positions(inds(1)),...
                obj.forces(inds(1):inds(end)), 'linewidth', width, 'Color', col,...
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
                plot(obj.forces, obj.measurements(:, ranking(1:n_ranked)), 'linewidth', 2,...
                    'color', [obj.color 0.5]);
                ylim([0 1]);
                box off
                set(gca, 'Fontsize', 15);
                set(gca, 'linewidth', 2);

            else
                % Otherwise plot all channels
                plot(obj.forces, (5/1023)*(obj.measurements-obj.measurements(1,:)), 'color', obj.color, 'linewidth', 2);
                box off
                set(gca, 'Fontsize', 15);
                set(gca, 'linewidth', 2);

            end
            % xlabel("Force (N)");
            % ylabel("Reading");
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

        function change = returnmaxchange(obj, max_force)
            %RETURNMAXCHANGE Return signal change of channels at max position

            if nargin == 2 && max(obj.forces) > max_force
                % If a maximum force is defined, only consider ramp up to this
                valid_inds = 1:find(obj.forces>max_force, 1, "first")-1;
            else
                valid_inds = 1:length(obj.positions);
            end

            fpositions = obj.positions(valid_inds);
            fmeasurements = obj.measurements(valid_inds, :);

            change = zeros([size(obj.measurements, 2), 1]);
            for i = 1:size(obj.measurements, 2)
                inds = find(fpositions == max(fpositions));
                change(i) = max(abs(fmeasurements(inds, i)-fmeasurements(1, i)));
            end
        end

        
        function [change, boundaryforces] = returnchangefromtemp(obj, n_ranked)
            %RETURNMAXCHANGE Return average signal change of top ranked
            %channels at max position due to temp change.
            % Also return max force change so this can be compared

            inds = find(obj.positions==max(obj.positions));
            obj.forces = obj.forces(inds);
            obj.temps = obj.temps(inds);
            obj.measurements = obj.measurements(inds, :);

            boundaryforces = [max(obj.forces(1:60)) min(obj.forces(end-20:end))];


            [coeff,~,~,~,~,~] = pca(obj.measurements);
            [~,ranking] = sort(mean(abs(coeff(:,1)), 2), 'descend');

            maxtempind = find(obj.temps==max(obj.temps));

            change = 0;
            for i = 1:n_ranked
                if obj.measurements(maxtempind(1), ranking(i))>obj.measurements(end, ranking(i))
                    change = change +...
                        max(obj.measurements(maxtempind(1):maxtempind(1)+10, ranking(i))) -...
                        min(obj.measurements(end-10:end, ranking(i)));
                else
                    change = change +...
                        max(obj.measurements(end-10:end, ranking(i)))-...
                        min(obj.measurements(maxtempind(1):maxtempind(1)+10, ranking(i)));
                end

            end
            change = change/n_ranked;
        end


        function [correlation] = returntempcorrelation(obj)
            %RETURNTEMPCORRELATION Return correlation of all signals and temperature

            inds = find(obj.positions==max(obj.positions));
            inds = inds(3:end); % Let measurements settle before temp changes
            obj.forces = obj.forces(inds);
            obj.temps = obj.temps(inds);
            obj.measurements = obj.measurements(inds, :);
            
            % correlation = 0;
            % for i = 1:size(obj.measurements, 2)
            %     correlation = correlation + abs(xcorr(normalize(obj.measurements(:, i), "range", [0 1]), normalize(obj.temps), 0));
            % end
            % correlation = correlation/size(obj.measurements, 2);

            correlation = zeros([size(obj.measurements, 2), 1]);
            for i = 1:size(obj.measurements, 2)
                correlation(i) = abs(xcorr(normalize(obj.measurements(:, i)), normalize(obj.temps), 0));
            end

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
            plot(obj.times, obj.forces, 'LineWidth', 2, 'color', obj.color);
            xlim([0 max(obj.times)]);
            set(gca, 'linewidth', 2, 'fontsize', 15);
            box off

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

            colorbar off
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