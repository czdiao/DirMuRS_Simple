classdef fFrameletTransform2D < WaveletData2D
    %FFRAMELETTRANSFORM2D Separable Framelet Transform in 2D. Implemented 
    %with transforms performed in frequency domain.
    %
    %   Theoretically speaking, all SEPARABLE 2D framelets (no matter real
    %   or complex) could be realized using this class.
    %
    %   For non-separable transforms, or transforms considering
    %   real/imaginary parts analysis, use TPCTF2D, which is implemented as
    %   the subclass of this class.
    %
    %   We can use WaveletData2D as interface. The output coefficients are
    %   stored in the structure:
    %   Highpass:
    %       coeff{level}{dir}:              
    %   Lowpass:
    %       coeff{nlevel+1}
    %
    % Note:
    %   The data structure in this class is supposed to be working for all 
    %   general tight framelet. (Including complex framelets, time domain
    %   transforms, etc.) We have all methods related to data structure,
    %   such as arithmetics, denoising tools, etc., implemented in this
    %   class. So other tight framelet transforms, such as TPCTF or time
    %   domain tight framelets, could be derived from this class.
    %
    %   Chenzhe
    %   Feb, 2016
    %
    
    properties
        % Filter Banks
        FilterBank_col;     % FilterBank(n)
        FilterBank_row;
    end
    
    methods     % constructor
        function obj = fFrameletTransform2D(fbcol, fbrow)
            obj.type = 'fFrameletTransform2D';
            if nargin > 0
                obj.FilterBank_col = fbcol;
                if nargin == 1
                    fbrow = fbcol;
                end
                obj.FilterBank_row = fbrow;
            end
        end
        
    end
    
    methods
        w = decomposition(obj, x)
        y = reconstruction(obj)
        plot_DAS_freq(obj, scale)
        plot_DAS_time(obj, scale)
    end
    
    methods  % filter norm calculation and normalization
        W = normcoeff(obj)
        W = unnormcoeff(obj)
        plotnorm(obj)
        nor = CalFilterNorm(obj, signal_size)   % the interface changed, no problem?
    end
    
    % needs to be tested
    methods  % denoising tools
        trueSig = calSigma(obj)     % done
        Sig_est = latentSigma(obj, sigmaN, opt)     % done
        W = LocalSoft(obj, Ssig_latent, SigmaN)     % done
        W = BiShrink(obj, Ssig_latent, SigmaN)  % done
    end
    
    
    methods(Static)        % fft2 and ifft2 of the wavelet coefficients
        wf = wfft2(wt);
        wt = wifft2(wf);
    end
    
    
    methods  % simple arithmetic of coefficients
        obj_new = plus(obj1, obj2)
        obj2 = times(C, obj1)
        obj_new = minus(obj1, obj2)
        
        %The following methods are still not implemented yet
        v = convert2array(obj)
        n = norm(obj, p)
    end
    
    
end

