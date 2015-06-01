function [ cellarray_new ] = InsertCell( cellarray, idata, n )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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

