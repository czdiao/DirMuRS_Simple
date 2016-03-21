classdef freqfilter2d
    %FREQFILTER2D 2D filters in frequency domain.
    %
    %   We implement this class to allow non-separable filters.
    %
    %   Chenzhe
    %   Feb, 2016
    %
    
    properties
        ffilter = [];
        rate = 2;   % default is 2, for dyadic wavelets
        
        %tmp properties
        EnergyPortion = 0; % l2 energy in image
        index = [0, 0];    % cindex in filter bank, use half integer, [-n+0.5, n-0.5] for even number filters
    end
    
    properties (Dependent)
        norm2;   % l2 norm of the filter, dependent on ffilter
    end
    
    methods     % constructor
        function obj = freqfilter2d(ff1d1, ff1d2)
            % This constructor can take ff1d1 and ff1d2 to be filter banks.
            % Then obj would also be a filter bank containing all the
            % tensor products.

            if nargin > 0
                len1 = length(ff1d1);
                len2 = length(ff1d2);
                obj(len1*len2) = freqfilter2d;
                count = 1;
                for i = 1:len1
                    for j = 1:len2
                        obj(count).ffilter = ff1d1(i).ffilter.' * ff1d2(j).ffilter;
                        
                        if ~isempty(ff1d1(i).index) && ~isempty(ff1d2(j).index)
                            obj(count).index = [ff1d1(i).index, ff1d2(j).index];
                        end
                        
                        count = count+1;
                    end
                end
            end
        end
    end
    
    methods     % get method for dependent norm2
        function nor = get.norm2(obj)
            if isempty(obj.ffilter)
                error('The filter is not set!');
            else
                nor = sqrt(sum(sum(abs(obj.ffilter).^2)));
            end
        end
    end
    
    methods
        % arithmetic operation
        obj_new = plus(obj1, obj2)
        obj2 = times(C, obj1)
        obj_new = minus(obj1, obj2)
        obj_new = add(obj1, obj2)
                
        % Downsample and upsample in frequency domain
        f2 = filterdownsample(ffilter_old, rate1, rate2)
%         f2 = filterupsample(ffilter_old, rate1, rate2)      % not implemented yet

        % Find the conjugate of the (time domain) complex filter
        ffilter2 = conj_ffilter(ffilter1)

        w = fconv(Ffilter, fdata)   % convolution of filter with data
        w = fanalysis(Ffilter, fdata) % analysis operation
        x = fsynthesis(FfilterBank, fdatacells)   % synthesis operation

        
        % plot filters
        plot_ffilter(obj, varargin) % plot 2d filter in frequency domain (abs value)
        
        checkPR( ffb, rate )
        
        % convert to time domain filter
        
    end
    
end

