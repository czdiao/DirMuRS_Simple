classdef FrameletUndec2D  < fFrameletTransform2D
    %FRAMELETUNDEC2D Framelet transform for 2D signal.
    %We still use the WaveletData2D interface. This class is performed in
    %time domain, while fFrameletTransform2D is performed in freq domain.
    %
    %   The transform and filters here should be all separale. So all
    %   operations are performed in tensor way.
    %
    %   This is an undecimated version of FrameletTransform2D class.
    %
    %
    %   Chenzhe
    %   April, 2016
    %
    
    methods     % constructor
        function obj = FrameletUndec2D(fbcol, fbrow)
            obj.type = 'FrameletUndec2D';
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
    end
    
end

