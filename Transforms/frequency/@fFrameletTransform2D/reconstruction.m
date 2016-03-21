function y = reconstruction( obj )
%RECONSTRUCTION Reconstruction of frequency domain framelet 2D transform
%
%
%   Chenzhe
%   Feb, 2016
%


FfilterBank_col = obj.FilterBank_col;
FfilterBank_row = obj.FilterBank_row;
w = obj.coeff;
w = obj.wfft2(w);   % Change the coeff into frequency domain
J = obj.nlevel;

LL = w{J+1};


for ilevel = J:(-1):1
    coeff = [LL, w{ilevel}];
    LL = d2fsynthesis( coeff, 2, FfilterBank_col, FfilterBank_row );
end

y = ifft2(LL);  % change the data back into time domain
% y = real(y);



end

