function [ fdata_new ] = fconj( fdata )
%FCONJ conjugate of the data in freq domain. Support fdata in 1D and 2D.
%
%   Both fdata and fdata_new are in freq domain, they are conjugate in time
%   domain. Just as output from fft2, the frequency start from 0.
%
%   Chenzhe
%   Feb, 2016
%

[M, N] = size(fdata);
ind1 = [1, M:(-1):2];
ind2 = [1, N:(-1):2];

fdata_new = fdata(ind1, ind2);
fdata_new = conj(fdata_new);


end

