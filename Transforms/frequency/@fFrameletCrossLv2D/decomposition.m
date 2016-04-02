function w = decomposition( obj, x )
%DECOMPOSITION Decomposition of fFrameletCrossLv2D class
%
%   Chenzhe
%   Mar, 2016
%

fdata = fft2(x);    % Change the data into frequency domain
nL = obj.nlevel;
FB_col = obj.FilterBank_col;
FB_row = obj.FilterBank_row;
ncol = length(FB_col);
nrow = length(FB_row);

w = cell(1, nL+1);

for ilevel = 1:nL
    % decompose in direction 1
    coeff1 = FBanalysis(FB_col, fdata, 2, 1);
    
    % decomposition in direction 2
    
    % for output of d1 hipass
    H = cell(0);    % hipass output
    J = 2;
    for jj = 2:ncol     % output of d1 hipass
        tmp = coeff1{jj};
        for j = 1:J     % decomposition level of d2
            tmp = FBanalysis(FB_row, tmp, 2, 2);  % decomposition in direction 2
            H = [H, tmp(2:end)];
            tmp = tmp{1};
        end
        H = [H, tmp];
    end
    
    % lowpass output
    coeffL = FBanalysis(FB_row, coeff1{1}, 2, 2);
    for jj = 2:nrow
        tmp = coeffL{jj};
        for j = 1:J-1
            tmp = FBanalysis(FB_col, tmp, 2, 1);
            H = [H, tmp(2:end)];
            tmp = tmp{1};
        end
        H = [H, tmp];
    end
    
    fdata = coeffL{1};  % lowpass
    w{ilevel} = H;
end

w{nL+1} = fdata;

w = obj.wifft2(w);  % Change the coeff back to time domain


end


function w = FBanalysis(ffb, fdata, rate, dim)
% analysis of freqfilter1d filter bank

len = length(ffb);
w = cell(1, len);
for i = 1:len
    w{i} = fanalysis(ffb(i), fdata, rate, dim);
end



end





