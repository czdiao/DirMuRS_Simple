classdef TPCTF2D < fFrameletNonSeparable2D
    %TPCTF2D Implementation of TP-CTF for 2D data.
    %The transform is implemented in frequency domain, in order to have
    %easier design of filters. Filters are nonseparable as freqfilter2d.
    %
    %   The output complex coefficients are stored in the same data 
    %   structure in property: coeff.
    %
    %   The extended use of TPCTF2D in addition to fFrameletNonSeparable2D
    %   are:
    %
    %       Focus on the complex framelets. Add some code to save and
    %       analyse the real coefficients.
    %           coeff{level}{dir}:              
    %               for complex coefficients
    %
    %           coeff_real{1}{ilevel}{iband}:
    %               collect all real parts of the coefficients. 16 bands for TPCTF6
    %           coeff_real{2}{ilevel}{iband}:
    %               imaginary parts of the coefficients. 16 bands for TPCTF6
    %           coeff_real{3}:
    %               lowpass output at last level
    %
    %
    %
    %
    %   Chenzhe
    %   Feb, 2016
    %
    
    properties
        
        pairmap;    % N by 2 matrix, store indices of pairs of conjugate bands for CTF transform
        coeff_real;
    end
    
    methods     % Constructor
        function obj = TPCTF2D(fb2d)
            obj.type = 'TPCTF2D';
            if nargin > 0
                obj.FilterBank2D = fb2d;
                obj.nband = length(fb2d)-1;
                obj.pairmap = obj.getpairmap;
            end
        end
    end
    
    methods 
        % The decomposition/reconstruction (and undecimated version)
        % inherited from fFrameletNonSeparable2D class also works for this
        % class. However, we could make use of the conjugate pair filters
        % property to make the transform faster. We can build transform
        % functions later based on pairmap.
        
        % For TPCTF, find pairs of conjugate bands from freqfilter2d.index
        % information
        pairmap = getpairmap(obj);
        
        % For TPCTF transform, separate real/imag coefficients
        coeff_real = getCoeffReal(obj)
        coeff = getCoeffComplex(obj)
        
        % Generate the frames, for plot use
        [fr_real, fr_imag] = getFramesReal(obj, N, fker)     % the real/imag part of getFrames, need to be tested
        
        % used for GSM, specific for TPCTF class because it works on
        % real/imaginary parts respectively.
        [Cwr, Cwi] = CalCovMatrix(obj, N, blocksize, fker)
        W  = GSMDenoise( obj, blocksize, Cwr, Cwi, sigmaN )
        
    end
    
    
    
    
    
    
end

