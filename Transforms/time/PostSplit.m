function [ W_new ] = PostSplit( W, u, dim )
%PostSplit
%   Split the filter with (u1, u2) by post-possessing the wavelet coefficients
%   Input:
%       W:            2d wavelet coefficient, should be a matrix
%       u:            1d filter used to split the coefficients
%       dim:          1 or 2, which dimension to split, 1 for rows, 2 for columns


% conjugate flip the filter
u = conjflip(u);

W_new = tconv(u, W, dim);




end

