function [ cellarray_new ] = DeleteCell( cellarray, n )
%DeleteCell Delete one cell from a cell array
%   Input:
%		cellarray:	input cell array
%		n	 :	the index of the cell to be deleted, n <= len(cellarray)
%   Output:
%		cellarray_new:	the new output cell array

% len = length(cellarray);
% cellarray_new = cell(1, len-1);
% 
% for i = 1:(n-1)
%     cellarray_new{i} = cellarray{i};
% end
% 
% for i = n:(len-1)
%     cellarray_new{i} = cellarray{i+1};
% end


cellarray(n) = [];
cellarray_new = cellarray;


end

