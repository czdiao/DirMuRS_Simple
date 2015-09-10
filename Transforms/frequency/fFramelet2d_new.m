function [ w ] = fFramelet2d_new( fdata, J, FfilterBank_col, FfilterBank_row )
%FFRAMELET2D_NEW 2D Framelet Transform in Frequency Domain.
%Input:
%   fdata:
%       2D data in frequency domain.
%   J:
%       level of decompositions.
%   FfilterBank_col:
%       Frequency Based Filter Bank for columns (freqfilter1d object array).
%   FfilterBank_row:
%       Frequency Based Filter Bank for rows (freqfilter1d object array).
%       Could be omitted if cols and rows are using the same filter bank.
%
%Output:
%   w:
%       framelet coefficients in frequency domain.
%
%   Author: Chenzhe Diao

if nargin == 3
    FfilterBank_row = FfilterBank_col;
end


w = cell(1, J+1);

for ilevel = 1:J
    [fdata, H] = d2fanalysis(fdata, 2, FfilterBank_col, FfilterBank_row);
    w{ilevel} = H;
end

w{J+1} = fdata;




end

