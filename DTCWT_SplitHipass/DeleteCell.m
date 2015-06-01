function [ cellarray_new ] = DeleteCell( cellarray, n )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

len = length(cellarray);
cellarray_new = cell(1, len-1);

for i = 1:(n-1)
    cellarray_new{i} = cellarray{i};
end

for i = n:(len-1)
    cellarray_new{i} = cellarray{i+1};
end

end

