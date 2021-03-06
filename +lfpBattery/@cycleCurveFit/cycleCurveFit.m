classdef cycleCurveFit < lfpBattery.curveFitInterface
    %CYCLECURVEFIT Interface for cycles to failure vs. DoD curve fits.
    %
    %Authors: Marc Jakobi, Festus Anyangbe, Marc Schmidt
    %         January 2017
    
    properties (Dependent)
        x; % fit function parameters
    end
    methods
        function d = cycleCurveFit(f, numParams, DoDN, N, varargin)
            if nargin < 2
                error('Not enough input arguments.')
            end
            x0 = zeros(numParams, 1);
            % Optional inputs
            p = inputParser;
            addOptional(p, 'x0', x0, @(x) isnumeric(x));
            addOptional(p, 'mode', 'both');
            parse(p, varargin{:})
            varargin = [{'x0', p.Results.x0}, varargin];
            % Main inputs
            rawx = DoDN;
            rawy = N;
            d = d@lfpBattery.curveFitInterface(f, rawx, rawy, [], varargin{:}); % Superclass constructor
            d.xxlim = [0; inf]; % set boundaries
            d.yylim = [0; inf];
        end
        function plotResults(d, varargin)
            %PLOTRESULTS: Compares a scatter of the raw data with the fit
            %in a figure window.
            plotResults@lfpBattery.curveFitInterface(d, varargin{:}); % Call superclas plot method
            xlabel('\itDoD')
            ylabel('Cycles to failure \itN')
            if max(d.rawY) / min(d.rawY) > 100
                set(gca,'yscale','log')
            end
        end
        %% Dependent setters
        function set.x(d, params)
            assert(numel(params) == 2, 'Wrong number of params')
            d.px = params;
            d.fit;
        end
        %% Dependet getters
        function params = get.x(d)
           params = d.px; 
        end
    end
    
end

