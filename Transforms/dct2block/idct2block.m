function [ x ] = idct2block( y, block_size )
%IDCT2BLOCK Inverse of dct2block
%Compute the inverse dct2, computed and saved as blocks.
%
%   Chenzhe
%   Feb, 2016

if nargin ==1
    block_size = 8;
end

if mod(size(y,1),block_size)~=0 || mod(size(y,2), block_size)~=0
    error('idct2block: size of y is not multiples of block_size!');
end

nrow = size(y, 1)/block_size;
ncol = size(y, 2)/block_size;

ind = 1:block_size;
x = zeros(size(y));

D = dctmtx(block_size);

for irow = 0:nrow-1
    for icol = 0:ncol-1
        r_ind = ind + irow*block_size;
        c_ind = ind + icol*block_size;
        y_crop = y(r_ind, c_ind);
        x_crop = D' * y_crop * D;
        x(r_ind, c_ind) = x_crop;
    end
end





end

