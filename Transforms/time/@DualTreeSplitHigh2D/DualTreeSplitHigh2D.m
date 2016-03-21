classdef DualTreeSplitHigh2D < DualTreeWavelet2D
    %DUALTREESPLITHIGH2D Dual Tree Complex Wavelet Transform, split
    %highpass filter. This class is for 2D.
    %
    %
    %
    %   Chenzhe
    %   Jan, 2016
    %
    
    properties
        u_hi;   % 2 filters as a filter bank to split hipass
    end
    
    methods
        function obj = DualTreeSplitHigh2D(FSFB, FB, u_hi)    % constructor
            obj@DualTreeWavelet2D(FSFB, FB);
            
            obj.type = 'DualTreeSplitHigh2D';
            obj.nband = 8;
            obj.u_hi = u_hi;
        end
        
        % The following 2 functions are also to be redefined
        w = decomposition(obj, x)
        y = reconstruction(obj)

        
    end
    
end

