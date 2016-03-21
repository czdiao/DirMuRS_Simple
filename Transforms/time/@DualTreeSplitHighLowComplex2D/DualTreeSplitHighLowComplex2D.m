classdef DualTreeSplitHighLowComplex2D < DualTreeWavelet2D
    %DUALTREESPLITHIGHLOWCOMPLEX2D Dual Tree Complex Wavelet Transform, split
    %highpass and lowpass filter. This class is for 2D.
    %
    %   This is a generalized version of DualTreeSplitHighLow2D class. The
    %   difference is that, the decomposition and reconstruction function
    %   can accept the u_hi or u_low to be complex filter banks.
    %
    %   Chenzhe Diao
    %   Jan, 2016
    %
    
    properties
        u_hi;
        u_low;
    end
    
    methods
        function obj = DualTreeSplitHighLowComplex2D(FSFB, FB, u_hi, u_low)    % constructor
            obj = obj@DualTreeWavelet2D(FSFB, FB);
            
            obj.type = 'DualTreeSplitHighLowComplex2D';
            obj.nband = 12;
            obj.u_hi = u_hi;
            obj.u_low = u_low;
        end
        
        w = decomposition(obj, x)
        y = reconstruction(obj)
    end
    
end

