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
        plotnorm(obj, val)
        nor = CalFilterNorm(obj, signal_size)   % the interface changed, no problem?
    end
    
    methods  % denoising tools
        trueSig = calSigma(obj)     % done
        Sig_est = latentSigma(obj, sigmaN, opt)     % done
        Sig_est = latentSigma_unnormalize(obj, sigmaN, opt) % unnormalized version, need to be implemented
        
        W = LocalSoft(obj, Ssig_latent, SigmaN)     % done
        W = LocalSoft_unnormalize(obj, Ssig_latent, SigmaN) % unnormalized version, need to be implemented
        W = LocalSoft_modified(obj, Ssig_latent, SigmaN, C)    % modified version of Local Soft

        W = BiShrink(obj, Ssig_latent, SigmaN)  % done
        
        W = SoftThresh(obj, T)      % Bandwise soft thresholding, lambda*T is the thresh value for each band
        
    end
    
    
    methods(Static)        % fft2 and ifft2 of the wavelet coefficients
        wf = wfft2(wt);
        wt = wifft2(wf);
    end
    
    
    methods  % simple arithmetic of coefficients
        obj_new = plus(obj1, obj2)
        obj2 = times(C, obj1)
        obj_new = minus(obj1, obj2)
        n = norm(obj, p)    % calculate lp norm of the wavelet coeff

        %The following methods are still not implemented yet
        v = convert2array(obj)
    end
    
    % this is to perform the same operation on each level and band
    methods    % operation on coefficients of each band, only work on hipass bands
        w_new = operate_band1(obj, fun_handle, w)
        w_new = operate_band2(obj, fun_handle, w1, w2)
        
    end
end

