classdef DataDist
    %DATADIST Empirical Data Distribution analysis
    %   
    %
    %   Chenzhe Diao
    %   Jan, 2016
    %
    
    properties
        % both returned by ecdf
        X;      % data points by removing the repeated data, strictly increasing, except the first number is repeated
        Fx;     % Empirical pdf, start with 0, end with 1. Length is the same as X
    end
    
    methods
        function obj = DataDist(data)
            [obj.Fx, obj.X] = ecdf(data);
        end
        
        function cdfplot(obj, varargin)
            plot(obj.X, obj.Fx, varargin{:})
        end
        
        function [p, c] = histval(obj, N)
            %Generate the histogram data with N bins.
            %Input:
            %   N:  number of bins
            %Output:
            %   p:  histogram bar height value, estimation of pdf
            %   c:  bin center position.
            %Note:
            %   The area of the whole histogram is 1. So this value is just
            %   the estimation of the pdf at position c.
            %
            
            c = linspace(obj.X(1), obj.X(end), N);
            p = ecdfhist(obj.Fx, obj.X, c);
        end
        
        function hist(obj, N)
            c = linspace(obj.X(1), obj.X(end), N);
            ecdfhist(obj.Fx, obj.X, c);
        end
        
        function edf1(obj, N)
            %Energy density function. Use L1 energy.
            % Simple version
            
            [p, c] = histval(obj, N);
            e = abs(c).*p;
            bar(c, e, 1);
        end
        
        function edf2(obj, N)
            %Energy density function. Use L2 energy.
            % Simple version
            
            [p, c] = histval(obj, N);
            e = c.^2 .* p;
            bar(c, e, 1);
        end
        
        
        
    end
    
end

