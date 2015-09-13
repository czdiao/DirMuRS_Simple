classdef filter2d
    %FILTER2D Class for 2d filter
    %   Properties:
    %       row_filter  :   1d vector    
    %       col_filter  :   1d vector
    %
    %       row_start_pt:   integer
    %       col_start_pt:   integer
    %
    %       row_label   :   char array. To label 'low', 'hi', etc. (Optional)
    %       col_label   :   char array. To label 'low', 'hi', etc. (Optional)
    %
    %   Methods:
    %       filter2d:   Constructor. Could be called as:
    %                       1) f = filter2d(f1d_row, f1d_col)
    %                       2) f = filter2d
    %
    %   Author: Chenzhe Diao
    
    properties
        row_filter = [];
        col_filter = [];
        row_start_pt = 0;
        col_start_pt = 0;
        row_label = '';
        col_label = '';
    end
    
    methods
        function f2d = filter2d(f1d_row, f1d_col) % Constructor
            % Construct 2d filter by tensor product of 2 1d filters
            if nargin < 2
                f1d_row = filter1d;
                f1d_col = filter1d;
            end
            f2d.row_filter = f1d_row.filter;
            f2d.row_start_pt = f1d_row.start_pt;
            f2d.row_label = f1d_row.label;
            
            f2d.col_filter = f1d_col.filter;
            f2d.col_start_pt = f1d_col.start_pt;            
            f2d.col_label = f1d_col.label;
        end
    end
    
end

