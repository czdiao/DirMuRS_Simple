classdef filter1d
    %FILTER1D Class for 1d filter
    %   Properties:
    %       filter  :   1d row vector
    %       start_pt:   integer
    %       norm    :   L2 norm, dependent variable
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
    %       tplot:          Stem plot the filter in time domain.
    %                           1)  tplot(f1d)
    %       upsamplefilter: Upsample the filter sequence.
    %                           1)  f1d_new = upsamplefilter(f1d, rate)
    %                           2)  f1d_new = f1d.upsamplefilter(rate)
    %       plus:           Add up two filter1d objects.
    %                           1)  f1d_new = f1d1 + f1d2
    %       times:          Scalar Multiplication. Must use dot product.
    %                       and put the scalar at the front. Works for
    %                       filter bank.
    %                           1)  f1d_new = C.*f1d;
    %       get.norm:           L2 norm of the filter.
    %                           1)  n = norm(f1d)
    %                           2)  n = f1d.norm
    %       Real:           Real part of the filter bank. This works for
    %                       filter bank.
    %                           1)  fb1d_real = Real(fb1d)
    %       Imag:           Imaginary part of the filter bank. This works
    %                       for filter bank.
    %                           1)  fb1d_imag = Imag(fb1d)
    %       conj:           Conjugate of the filter bank.
    %                           1)  fb1d_conj = conj(fb1d)
    %       freqshift:      Shift the filter bank in frequency domain.
    %                       \hat{fb1d_new}(xi) = \hat{fb1d}(xi - xi0)
    %                           1)  fb1d_new = freqshift(fb1d, xi0)
    %
    %       ImpulseResponse:
    %                       Impulse Response of the filter.
    %                       The k-th element of the filter. Notice that we
    %                       only accept 1 integer k as input, no array.
    %                           1)  ir = ImpulseResponse(f1d, k)
    %
    %       FreqResponse:   Frequency Response of the filter.
    %                       Output \hat{u}(\xi), 2pi periodic.
    %                       Input xi could be a vector or matrix, the
    %                       output would be of the same size.
    %                           1)  fr = FreqResponse(f1d, xi)
    %
    %       IntNegReal:     Integration of the Filter on the negative
    %                       frequency domain. 
    %                           \int_{-pi}^0 \hat{u}(\xi) d\xi
    %                           1)  Int = IntNegReal(u);
    %
    %   Author: Chenzhe Diao
    %   Data:   July, 2015
    
    properties
        filter = [];    % filter, 1d row vector
        start_pt = 0;   % integer, starting point of the filter
        norm;           % Dependent variable for L2 norm, see get.norm method
        label = '';     % label of the filter, char array. 'low', 'high', etc.
    end
    
    methods  % Constructor
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
        
        % filter set method, to ensure filter is a row vector
        function obj = set.filter(obj, val)
            if (~isvector(val)) && (~isempty(val))
                error('filter1d should take 1d filter!');
            elseif iscolumn(val)
                val = val.';    % transpose without complex conjugation
            end
            obj.filter = val;
        end
    end
    
    methods
        highpass = CQF(lowpass)
        
        f1d_flip = conjflip(f1d)
        
        ff1d = convert_ffilter(tfilters, N)     
        
        function f = convfilter(u, v)         
            %%1d filter convolution
            vec = conv(u.filter,v.filter);
            pt = u.start_pt + v.start_pt;
            f = filter1d(vec, pt);
            
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
        
        function tplot(obj)
            len = length(obj.filter);
            x = obj.start_pt:(obj.start_pt+len-1);
            stem(x, obj.filter);
        end
        
        function f1d_new = upsamplefilter(f1d, rate)
            f1d_new = f1d;
            f1d_new.filter = tupsample(f1d.filter, rate);
            f1d_new.start_pt = f1d.start_pt*rate;
        end
        
        function f1d_new = plus(f1d1, f1d2)
            f1d_new = f1d1;
            
            if f1d1.start_pt > f1d2.start_pt
                f1d1 = f1d2;
                f1d2 = f1d_new;
            end
            
            f1d_new.start_pt = f1d1.start_pt;
            d1 = f1d2.start_pt - f1d1.start_pt;
            f1d2.filter = [zeros(1,d1), f1d2.filter];
            
            d2 = length(f1d1.filter) - length(f1d2.filter);
            if d2>=0
                f2 = [f1d2.filter, zeros(1, d2)];
                f1 = f1d1.filter;
            else
                f1 = [f1d1.filter, zeros(1, -d2)];
                f2 = f1d2.filter;
            end
            
            f1d_new.filter = f1 + f2;
            
        end
        
        function fb1d_new = times(C, fb1d)
            % scalar product
            fb1d_new = fb1d;
            N = length(fb1d);
            for i = 1:N
                fb1d_new(i).filter = fb1d(i).filter * C;
            end
        end
        
        function n = get.norm(f1d)
            n = sum(abs(f1d.filter).^2);
            n = sqrt(n);
        end
        
        function fb1d_real = Real(fb1d)
            %The real part of the filter in a filter bank
            len = length(fb1d);
            fb1d_real = fb1d;
            for i = 1:len
                fb1d_real(i).filter = real(fb1d(i).filter);
            end
        end
        
        function fb1d_imag = Imag(fb1d)
            %The imaginary part of the filter in a filter bank
            len = length(fb1d);
            fb1d_imag = fb1d;
            for i = 1:len
                fb1d_imag(i).filter = imag(fb1d(i).filter);
            end
        end
        
        function fb1d_conj = conj(fb1d)
            %%Conjugate of the filter bank.
            fb1d_conj = fb1d;
            N = length(fb1d);
            for i = 1:N
                fb1d_conj(i).filter = conj(fb1d(i).filter);
            end
        end
        
        function fb1d_new = freqshift(fb1d, xi0)
            %%Shift the filter bank in Frequency domain by xi0
            %   \hat{fb1d_new}(xi) = \hat{fb1d}(xi - xi0)
            fb1d_new = fb1d;
            N = length(fb1d);
            
            for i = 1:N
                len = length(fb1d(i).filter);
                ind = fb1d(i).start_pt;
                for k = 1:len
                    fb1d_new(i).filter(k) = fb1d(i).filter(k) * exp(1i*ind*xi0);
                    ind = ind + 1;
                end
            end
        end
        
        function ir = ImpulseResponse(f1d, k)
            %%Impulse Response:
            % Return u(k)
            % Only accept integer k input, not array.
            
            pt = f1d.start_pt;
            l = length(f1d.filter);
            
            if k<pt
                ir = 0;
            elseif k>= pt+l
                ir = 0;
            else
                ind = k-pt + 1;
                ir = f1d.filter(ind);
            end
            
        end
        
        function fr = FreqResponse(f1d, xi)
            %%The frequency response of the filter. \hat{u}(exp(i\xi))
            % The function could take vector input xi.
            
            pt = f1d.start_pt;
            L = length(f1d.filter);
            
            xi_reshape = xi(:); %column vector
            y = exp(-1i*xi_reshape);
            fr_reshape = zeros(size(y));
            
            for k = pt:(pt+L-1)
                fr_reshape = fr_reshape + y.^k * f1d.ImpulseResponse(k);
            end
            
            fr = reshape(fr_reshape, size(xi));
            
        end
        
        function fplot(obj, varargin)
            xi = -pi:0.01:pi;
            y = obj.FreqResponse(xi);
            plot(xi, abs(y), varargin{:}); xlim([-pi,pi]); hold on;
            set(gca,'XTick',linspace(-pi,pi,5)); grid on;
        end
        
        function Int = IntNegReal(u)
            %%Integration of real filter in the frequency domain.
            %   Only works for \hat{u} real on \xi \in [-pi, pi]
            %       which means: u(-k) = conj(u(k))
            %   \int_{-pi}^0 \hat{u}(\xi) d\xi
            
            max_ind = -u.start_pt;
            Int = 0;
            for ind = 1:2:max_ind
                Int = Int - 4 * imag(u.ImpulseResponse(ind))/ind;
            end
            
            Int = Int + u.ImpulseResponse(0)*pi;
        end
        
        function Int = IntPosReal(u)
            
            
            max_ind = -u.start_pt;
            Int = 0;
            for ind = 1:2:max_ind
                Int = Int + 4 * imag(u.ImpulseResponse(ind))/ind;
            end
            
            Int = Int + u.ImpulseResponse(0)*pi;
        end
        
        function var = Variance(f1d)
            %%Variance of the filter
            % This is invariant w.r.t. shift  of the filter.
            
            n = f1d.norm;
            f = abs(f1d.filter).^2/n^2;
            Len = length(f);
            s = 1:Len;
            E = f*s'; % expectation
            var = (s-E).^2 * f';
            
        end
        
        function u2 = sq(u)
            %%Square in Frequency domain
            %   u2(z) = u(z)u^*(z), positive on unit circle
            
            u2 = u.convfilter(u.conjflip);
           
        end
        
    end
    
    
end

