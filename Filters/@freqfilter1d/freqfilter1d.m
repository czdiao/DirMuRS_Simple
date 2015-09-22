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
    end
    
    methods
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
        
        function fhi = fCQF(flow)
            %Generate highpass from lowpass by CQF pairs in Freq domain.
            
            len = length(flow.ffilter);
            if mod(len, 2)~=0
                error('Cannot Generate Highpass filter from lowpass!');
            end
            
            I = sqrt(-1);
            theta = 0:1/len:(len-1)/len;
            theta = -theta*2*pi*I;
            
            c = exp(theta);
            f = conj(fftshift(flow.ffilter));
            fhi = freqfilter1d;
            fhi.ffilter = c.*f;
            
        end
        
        function f2 = filterdownsample(ffilter_old, rate)
            %Downsample the Frequency based filter.
            % rate is the downsampling rate.
            len = length(ffilter_old.ffilter);
            if mod(len, rate)~=0
                error('Wrong Sampling Rate for Frequency Filters!');
            end
            f2 = freqfilter1d;
            f2.ffilter = ffilter_old.ffilter(1:rate:end);
%             f2.ffilter = downsample(ffilter_old.ffilter, rate);
        end % filterdownsample
        
        function plot_ffilter(obj, varargin)
            % Plot filter in frequency domain. Plot \xi in [-pi, pi].
            Nfilters = length(obj);
            for i = 1:Nfilters
                len = length(obj(i).ffilter);
                dx = 2*pi/len;
                if mod(len, 2)==0
                    x = linspace(-pi,pi-dx,len);
                else
                    x = linspace(-pi+dx/2,pi-dx/2, len);
                end
                
                y = fftshift(abs(obj(i).ffilter));
%                 figure;
                plot(x, y, varargin{:}); xlim([-pi,pi]); hold on;
                set(gca,'XTick',linspace(-pi,pi,5)); grid on;
            end
        end %plot_ffilter

    end %methods
    
end

