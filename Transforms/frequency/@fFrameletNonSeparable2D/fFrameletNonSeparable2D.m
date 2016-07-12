classdef fFrameletNonSeparable2D  < fFrameletTransform2D
    %FFRAMELETNONSEPARABLE2D Implementation of NonSeparable freq framelet for 2D data.
    %The transform is implemented in frequency domain, in order to have
    %easier design of filters.
    %
    %   We can use fFrameletTransform2D as interface. The output 
    %   coefficients are stored in the same data structure in property:
    %   coeff.
    %
    %   The extended use of this class in addition to fFrameletTransform2D
    %   is:
    %
    %       We allow nonseparable filters. So we use freqfilter2d structure
    %       in the filter banks. Also, the transforms are performed with 2d
    %       filters directly.
    %
    %
    %
    %
    %   Chenzhe
    %   July, 2016
    %
    
    properties
        % Filter Bank, stored as freqfilter2d filters to allow nonseparable
        % transforms.
        FilterBank2D;
    end
    
    
    methods     % Constructor
        function obj = fFrameletNonSeparable2D(fb2d)
            obj.type = 'fFrameletNonSeparable2D';
            if nargin > 0
                obj.FilterBank2D = fb2d;
                obj.nband = length(fb2d)-1;
            end
        end
    end
    
    
    methods
        % transforms, using 2d filters directly
        w = decomposition(obj, x)
        y = reconstruction(obj)
        
        % undecimated version of the transform, used in getFrames()
        w = decomposition_undecimated(obj, x)
        y = reconstruction_undecimated(obj)
        
        % Generate the frames, for norm/cov matrix calculation, or plot use
        fr = getFrames(obj, N)
        fr = getFrames_blur(obj, N, fker)
        
        % filter norm calculation could be based on getFrames(), which is faster.
        nor = CalFilterNorm(obj, signal_size)   % need to be tested
        nor = CalFilterNorm_blur(obj, signal_size, ker)     %   need to be tested
    end
    
end

