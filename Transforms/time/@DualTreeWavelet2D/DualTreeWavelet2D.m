classdef DualTreeWavelet2D  <  WaveletData2D
    %DUALTREEWAVELET Class for the Dual Tree Complex Wavelet Transform
    %   This is a concrete subclass of the abstract WaveletData2D
    %
    %   WaveletData2D focus on the data
    %
    %
    %   Chenzhe Diao
    %   Jan, 2016
    %
    
%     properties      %properties inherited from WaveletData2D
%         coeff ;     % the wavelet decomposition coefficients
%         type ;      % type of transform
%         nlevel;     % number of levels of decomposition
%         nband;
%         
%         nor;
%         level_norm;
%     end
    
    properties      %properties of this class
        % filter banks: stored in cell array with 2 cells for 2 trees, each
        % cell is a filter bank with 2 filters(lowpass and hipass). For
        % example, see DualTree_FilterBank_Zhao().
        FirstStageFB;
        FilterBank;
        
    end
    
    methods     % Constructor
        function obj = DualTreeWavelet2D(FSFB, FB)  % constructor
            if nargin > 0
                obj.type = 'DualTreeWavelet2D';
                obj.nband = 3;
                obj.FirstStageFB = FSFB;
                obj.FilterBank = FB;
            end
        end
    end
    
    methods     % simple arithmetic of coefficients
        obj_new = plus(obj1, obj2)
        obj2 = times(C, obj1)
        obj_new = minus(obj1, obj2)
        v = convert2array(obj)
        n = norm(obj, p)    % not implemented yet
    end
    
    methods    % Transforms, filter norm calculation and normalization
        w = decomposition(obj, x)
        y = reconstruction(obj)
        nor = CalFilterNorm(obj)
        W = normcoeff(obj)
        W = unnormcoeff(obj)
        plotnorm(obj)
        plot_DAS_time(obj, scale)
        plot_DAS_freq(obj, scale)
    end
    
    methods    % denoising tools
        trueSig = calSigma(obj)   % Calculate the local std of the wavelet coefficients.
        Sig_est = latentSigma(obj, sigmaN, opt)     % Estimate the latent local std of the wavelet coeff.
        W = LocalSoft(obj, Ssig_latent, SigmaN)     % local soft-thresholding
        W = BiShrink(obj, Ssig_latent, SigmaN)      % bivariate shrinkage
    end
    
    methods    % check local coeff
        
        % find all the wavelet coeff corresponding to position (i,j) in the original image
        v = getlocalcoeff(obj,i, j) 
        coeff = keeplocalcoeff(obj, Ind)

    end
    
    
    
end

