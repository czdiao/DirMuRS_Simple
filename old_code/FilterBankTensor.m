function [ FilterBank2D ] = FilterBankTensor( row_filter_bank, col_filter_bank )
%FILTERTENSORMULTIPLE Tensor Product 2 1d filter banks into a 2d filter bank
%   Input:
%           row_filter_bank   :  1*M array of filter1d, the first one
%                                is supposed to be the low pass
%
%           col_filter_bank   :  1*N array of filter1d, the first one
%                                is supposed to be the low pass
%   Output:
%           FilterBank2D:       2d filter array, length = M*N



M = length(row_filter_bank);
N = length(col_filter_bank);

FilterBank2D(M*N) = filter2d;   % preallocation of memory

count = 0;
for i = 1:M
    for j = 1:N
        count = count+1;
        FilterBank2D(count) = filter2d(row_filter_bank(i), col_filter_bank(j));
    end
end



end

