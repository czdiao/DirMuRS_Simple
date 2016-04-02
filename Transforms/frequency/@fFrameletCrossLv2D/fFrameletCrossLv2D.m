classdef fFrameletCrossLv2D < fFrameletTransform2D
    %FFRAMELETCROSSLV2D Framelet Transform in 2D. With tensor of different
    %levels of 2 directions.
    %
    %   Similar to fFrameletTransform2D. Test for x direction 1st level
    %   tensor y direction 2nd level DAS.
    %
    %   Chenzhe
    %   Mar, 2016
    %
    
    properties
    end
    
    methods     % constructor
        function obj = fFrameletCrossLv2D(fbcol, fbrow)
            obj.type = 'fFrameletCrossLv2D';
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

