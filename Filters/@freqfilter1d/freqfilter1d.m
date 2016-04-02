classdef freqfilter1d
    %FREQFILTER1D Frequency based 1d filters
    %   Properties:
    %       ffilter     :   Frequency based filter in 1d.
    %                       1d array. starting with \xi = 0, end at \xi =
    %                       2pi*(N-1)/N. (N = length(ffilter))
    %       
    %       
    %   Methods:
    %       freqfilter1d   :   constructor.
    %                           1)  f = freqfilter1d;
    %                           2)  f = freqfilter1d(func_handle, N)
    %                               N is the number of sample points.
    %
    %       fCQF           :   Generate highpass from lowpass by CQF pairs in Freq domain.
    %                          b(\xi) = exp(-I\xi)*conj(a(\xi+pi)).
    %                           1) fhigh = fCQF(flow)
    %                           2) fhigh = flow.fCQF
    %                          Note:
    %                           This function only works for even length flow filters.
    %                           Otherwise, we cannot get a(\xi+pi) by shifting.
    %
    %       filterdownsample :  downsampling of the freqfilter1d by d, to get a
    %                           new freqfilter1d object for next level transform.
    %                               1)  f2 = filterdownsample(ffilter, d)
    %                               2)  f2 = ffilter.filterdownsample(d)
    %
    %       plot_ffilter:   plot the frequency based filter in 1d.
    %                       Plot in \xi \in [-pi, pi]
    %                           1)  plot_ffilter(obj, varargin) % varargin is for plot options.
    %                           2)  obj.plot_ffilter(varargin)
	%
	%       fconv		:	convolution of data and filter in frequency domain.
    %                           1) w = fconv(Ffilter, fdata, dim)
    %                           2) w = Ffilter.fconv(fdata, dim)
    %                           3) w = fconv(Ffilter, fvector)
    %                           4) w = Ffilter.fconv(fvector)
    %                       
	%       fanalysis   :   Analysis operation.
    %                           1)  w = fanalysis(Ffilter, fdata, rate, dim)
    %                           2)  w = Ffilter.fanalysis(fdata, rate, dim)
    %                           3)  w = fanalysis(Ffitler, fvector, rate)
    %                           4)  w = Ffilter.fanalysis(fvector, rate)
    %       
    %       fsynthesis  :   Synthesis operation.
    %                           1)  w = fsynthesis(FfilterBank, fdatacells, rate, dim)
    %                           2)  w = fsynthesis(FfitlerBank, fvectorcells, rate)
    %
    %   Author: Chenzhe Diao
    %   Date:   July, 2015
    
    properties
        ffilter = []; % row vector, frequency based filter.
        index;
    end
    
    methods     % Constructor and Property Set method
        function f = freqfilter1d(func, N)
            %%Constructor using function handle.
            % Input:
            %       func is the function handle for filter frequency \hat{f}.
            %       N is the number of sample points in [0, 2*pi)
            % nargin==0 for default constructor, initialized to [].
            if nargin ~= 0
                if nargin == 1
                    N = 64;
                end
                dx = 2*pi/N;
                x = linspace(0, 2*pi-dx, N);
                f.ffilter = func(x);
            end
        end %freqfilter1d
        
        % ffilter set method, to ensure ffilter is a row vector
        function obj = set.ffilter(obj, val)
            if ~isvector(val)
                error('freqfilter1d should take 1d filter!');
            elseif iscolumn(val)
                val = val.';    % transpose without complex conjugation
            end
            obj.ffilter = val;
        end
    end
    
    methods
        obj_new = add(obj1, obj2)
        fhi = fCQF(flow)
        f2 = filterdownsample(ffilter_old, rate)  % used to filter shorter signals, this is not time domain downsample
        
        f2 = upsamplefilter(ffilter_old, rate);   % corresponds to a time domain upsample

        w = fconv(Ffilter, fdata, dim)
        w = fanalysis(Ffilter, fdata, rate, dim)
        x = fsynthesis(FfilterBank, fdatacells, rate, dim)
        
        plot_ffilter(obj, varargin)
        tfilters = convert_tfilter(ffilters)
        
        % Find the conjugate of the (time domain) complex filter
        ffilter2 = conj_ffilter(ffilter1)
        
        checkPR(ffb, rate)    % Check the PR condition for filter bank
        
        
    end
    
end

