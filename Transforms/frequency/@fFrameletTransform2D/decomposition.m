function w = decomposition( obj, x )
%DECOMPOSITION Decomposition of fFrameletTransform2D.
%
%
%   Chenzhe
%   Feb, 2016
%

fdata = fft2(x);    % Change the data into frequency domain
nL = obj.nlevel;
FB_col = obj.FilterBank_col;
FB_row = obj.FilterBank_row;

w = cell(1, nL+1);

for ilevel = 1:nL
    [fdata, H] = d2fanalysis(fdata, 2, FB_col, FB_row);
    w{ilevel} = H;
end

w{nL+1} = fdata;

w = obj.wifft2(w);  % Change the coeff back to time domain


end

