function y = dct2block( x, block_size )
%DCT2BLOCK Perform the dct2 by blocks. We take the transform on each block
%to overcome the lack of time localization of dct2.
%
%   Chenzhe
%   Feb, 2016


if nargin ==1
    block_size = 8;
end

if mod(size(x,1),block_size)~=0 || mod(size(x,2), block_size)~=0
    error('dct2block: size of x is not multiples of block_size!');
end

nrow = size(x, 1)/block_size;
ncol = size(x, 2)/block_size;

ind = 1:block_size;
y = zeros(size(x));

D = dctmtx(block_size);

for irow = 0:nrow-1
    for icol = 0:ncol-1
        r_ind = ind + irow*block_size;
        c_ind = ind + icol*block_size;
        x_crop = x(r_ind, c_ind);
        y_crop = D * x_crop * D';
        y(r_ind, c_ind) = y_crop;
    end
end



end

