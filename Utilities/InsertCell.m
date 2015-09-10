function [ cellarray_new ] = InsertCell( cellarray, idata, n )
%InsertCell Insert one cell into a cell array
%   Input:
%	cellarray :	original cell array of length len
%	idata     :	the data to be put into a new cell
%	n	  :	insert the new cell to position n
%   Output:
%	cellarray_new:	new cell array of length (len+1)

len = length(cellarray);

cellarray_new = cell(1, len+1);

for i = 1:(n-1)
    cellarray_new{i} = cellarray{i};
end

cellarray_new{n} = idata;

for i = n:len
    cellarray_new{i+1} = cellarray{i};
end


end

