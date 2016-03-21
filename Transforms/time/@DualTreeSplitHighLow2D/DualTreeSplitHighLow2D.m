classdef DualTreeSplitHighLow2D < DualTreeWavelet2D
    %DUALTREESPLITHIGHLOW2D Dual Tree Complex Wavelet Transform, split
    %highpass and lowpass filter. This class is for 2D.
    %
    %   This class can only deal with real filter banks u_hi and u_low. For
    %   a more generalized version, use DualTreeSplitHighLowComplex2D
    %
    %   Chenzhe
    %   Jan, 2016
    %
    
    properties
        u_hi;
        u_low;
    end
    
    methods
        function obj = DualTreeSplitHighLow2D(FSFB, FB, u_hi, u_low)    % constructor
            obj = obj@DualTreeWavelet2D(FSFB, FB);
            
            obj.type = 'DualTreeSplitHighLow2D';
            obj.nband = 12;
            obj.u_hi = u_hi;
            obj.u_low = u_low;
        end
        
        % reimplement these functions for this subclass
        w = decomposition(obj, x)
        y = reconstruction(obj)
    end
    
end

