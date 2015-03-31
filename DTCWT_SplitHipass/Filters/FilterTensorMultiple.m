function [ filter2d ] = FilterTensorMultiple( row_filter, col_filter )
%FILTERTENSORMULTIPLE Tensor Product 2 sets of 1d filters into 2d filters
%   Input:
%           row_filter(M):  1*M array of structure 1d filter, the first one
%                           is supposed to be the low pass
%
%           col_filter(N):  1*N array of structure 1d filter, the first one
%                           is supposed to be the low pass
%   Output:
%           filter2d:       2d filter array, length = M*N



M = length(row_filter);
N = length(col_filter);


count = 0;
for i = 1:M
    for j = 1:N
        count = count+1;
        filter2d(count) = FilterTensor(row_filter(i), col_filter(j));
    end
end



end

