classdef TPCTF2D < fFrameletTransform2D
    %TPCTF2D Implementation of TP-CTF for 2D data.
    %The transform is implemented in frequency domain, in order to have
    %easier design of filters.
    %
    %   We can use fFrameletTransform2D as interface. The output complex
    %   coefficients are stored in the same data structure in property:
    %   coeff.
    %
    %   The extended use of TPCTF2D in addition to fFrameletTransform2D
    %   are:
    %
    %   (1) Focus on the complex framelets. Add some code to save and
    %       analyse the real coefficients.
    %       Highpass:
    %           coeff{level}{dir}:              
    %               for complex coefficients
    %           coeff_real{level}{dir}{part}:   
    %               for real coefficients, where the part=1 for real, part=2 for imaginary
    %       Lowpass:
    %           coeff{nlevel+1} and coeff_real{nlevel+1} are the same thing
    %   (2) We allow nonseparable filters. So we use freqfilter2d structure
    %       in the filter banks. Also, the transforms are performed with 2d
    %       filters directly.
    %
    %
    %   Note:
    %       The structure for coeff (complex coeff) could be the same for
    %       any framelet transform. We keep this as primary use and stored
    %       variable. We make coeff_real to be dependent on coeff.
    %
    %
    %   Chenzhe
    %   Feb, 2016
    %
    
    properties
        % Filter Bank, stored as freqfilter2d filters to allow nonseparable
        % transforms.
        FilterBank2D;
        
        coeff_real;
    end
    
    methods     % Constructor
        function obj = TPCTF2D(fb2d)
            obj.type = 'TPCTF2D';
            if nargin > 0
                obj.FilterBank2D = fb2d;
                obj.nband = length(fb2d)-1;
            end
        end
    end
    
    methods % transforms, using 2d filters directly
        w = decomposition(obj, x)
        y = reconstruction(obj)
        coeff_real = RealCoeff(obj)        % not implemented yet

    end
    
    methods(Static)
        [L, H] = d2fanalysis_ctf(fdata, rate, FB_col, FB_row) % bugs, doesn't work
        [ x ] = d2fsynthesis_ctf( w, rate, Ffb_c, Ffb_r ) % bugs, doesn't work
        
    end
    
    
    
    
    
end

