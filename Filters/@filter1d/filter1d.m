classdef filter1d
    %FILTER1D Class for 1d filter
    %   Properties:
    %       filter  :   1d vector
    %       start_pt:   integer
    %       label   :   char array. To label 'low', 'hi', etc. (Optional)
    %
    %   Methods:
    %       filter1d:   Constructor. Could be called as:
    %                       1) f = filter1d(vec, pt, label)
    %                       2) f = filter1d(vec, pt)
    %                       3) f = filter1d
    %
    %       CQF     :   Generate highpass from lowpass by CQF pairs.
    %                       1) hi = CQF(low)
    %                       2) hi = low.CQF
    %                   where low and hi are both filter1d objects.
    %
    %       conjflip:   conjugate flip of the filter.
    %                       1) f1d_flip = conjflip(f1d)
    %                       2) f1d_flip = f1d.conjflip
    %
    %       convfilter: Convolution of 2 1d filters.
    %                       1) f = convfilter(u, v)
    %                       2) f = u.convfilter(v)
    %                   where u, v, f are all filter1d objects.
    %
    %       tconv:      Convolution of filter and data in time domain.
    %                       1) w = tconv(f1d, data, dim)
    %                       2) w = f1d.tconv(data,dim)
    %
    %       analysis:   Time domain analysis operation of the data
    %                       1)  w = analysis(f1d, data, rate, dim)
    %                       2)  w = f1d.analysis(f1d, data, rate)
    %                       3)  w = analysis(f1d, vectordata, rate)
    %
    %       synthesis:  Time domain synthesis operation.
    %                       1)  x = synthesis(FilterBank, datacells, rate, dim)
    %                       2)  x = synthesis(FilterBank, vectorcells, rate)
    %
    %       analysis_old:   Exactly the same as analysis.m function.
    %                       Separate the convolution and downsampling
    %                       processes. Runs slower.
    %
    %       synthesis_old:  Exactly the same as synthesis.m function.
    %                       Separate the upsampling and convolution
    %                       processes. Runs slower.
    %
    %       convert_ffiler: convert time domain filter filter1d object to
    %                       frequency based filter freqfilter1d.
    %                           1)  ff1d = convert_ffilter(tfilter, N)
    %                           2)  ff1d = tfilter.convert_ffilter(N)
    %
    %       checkfilter:    Check and fix the filter bank alignment. Should
    %                       be called before analysis and synthesis function.
    %                       Note:
    %                           This function can accept filter array. (filter bank)
    %                           1)  fb1d_new = checkfilter(fb1d, rate)
    %
    %   Author: Chenzhe Diao
    %   Data:   July, 2015
    
    properties
        filter = [];    % filter, 1d row vector
        start_pt = 0;   % integer, starting point of the filter
        label = '';     % label of the filter, char array. 'low', 'high', etc.
    end
    
    methods
        function f1d = filter1d(vec, pt, label)  % constructor
            if nargin == 2
                label = '';
            elseif nargin < 2
                vec = [];
                pt = 0;
                label = '';
            end
            f1d.filter = vec;
            f1d.start_pt = pt;
            f1d.label = label;
        end
        
        function highpass = CQF(lowpass)
            %%CQF alternating shift for constructing highpass
            % Generate the 1D highpass filter from lowpass filter in CQF pairs
            % $b_n = (-1)^(n+1) a_{1-n}$
            len = length(lowpass.filter);
            highpass = filter1d;
            highpass.filter = conj(lowpass.filter(end:-1:1));
            highpass.start_pt = 1 - (lowpass.start_pt + len - 1);
            
            flip = ones(1,len);
            if mod(highpass.start_pt, 2)==1
                s = 2;
            else
                s = 1;
            end
            
            for i = s:2:len
                flip(i) = -1;
            end
            
            highpass.filter = highpass.filter.*flip;
            highpass.label = 'high';
        end
        
        function f1d_flip = conjflip(f1d)   
            %%Conjugate flip of the filter
            len = length(f1d.filter);
            flip_start_pt = (f1d.start_pt + len - 1) * (-1);
            
            f1d_flip = filter1d;
            f1d_flip.filter = conj(f1d.filter(end:-1:1));
            f1d_flip.start_pt = flip_start_pt;
            f1d_flip.label = f1d.label;

        end
        
        function f = convfilter(u, v)         
            %%1d filter convolution
            vec = conv(u.filter,v.filter);
            pt = u.start_pt + v.start_pt;
            f = filter1d(vec, pt);
            
        end
        
        function ff1d = convert_ffilter(tfilters, N)     
            %%Convert time domain filter filter1d objects to frequency domain filter freqfilter1d
            len = length(tfilters);
            ff1d(len) = freqfilter1d;
            for i = 1:len
                num_zeros = N-length(tfilters(i).filter);
                ff = [tfilters(i).filter, zeros(1,num_zeros)];
                ff = circshift2d(ff, 0, tfilters(i).start_pt);
                ff = fft(ff);
                ff1d(i).ffilter = ff;
            end
        end
        
        function fb1d_new = checkfilter(fb1d, rate)
            %%Check and fix the filter length and start_pt. (Without changing the actual filters.)
            %   This function should be called before analysis and
            %   synthesis operations. Since in these 2 operations, decimation and convolution
            %   operations are combined for speed, this function gaurentees
            %   the decimation is deleting the correct coset.
            %Input:
            %   fb1d:
            %       filter bank. filter1d array.
            %   rate:
            %       decimation (down/upsampling rate used.)
            %Output:
            %   fb1d_new:
            %       fixed filter bank.
            %
            %   Author: Chenzhe Diao
            %   Date:   July, 2015
            %
            
            Nfilters = length(fb1d); % Number of filters.
            
            fb1d_new = fb1d;
            for iFilter = 1:Nfilters
                pt = fb1d(iFilter).start_pt;
                if mod(pt,rate)~=0
                    pt_shift = mod(pt, rate);
                    fb1d(iFilter).start_pt = pt - pt_shift;
                    fb1d(iFilter).filter = [zeros(1,pt_shift), fb1d(iFilter).filter];
                end
                
                Layer = length(fb1d(iFilter).filter)-1;
                if mod(Layer, rate)~=0
                    L_add = rate - mod(Layer, rate);
                    fb1d(iFilter).filter = [fb1d(iFilter).filter, zeros(1, L_add)];
                end
                
                fb1d_new(iFilter) = fb1d(iFilter);
            end
        end
        
    end
    
    
end

