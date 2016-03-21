function y = reconstruction( obj )
%RECONSTRUCTION Reconstruction of TP-CTF 2D transform
%
%
%   Chenzhe
%   Feb, 2016
%

FB = obj.FilterBank2D;
w = obj.coeff;
w = obj.wfft2(w);   % Change the coeff into frequency domain
J = obj.nlevel;

LL = w{J+1};

for ilevel = J:(-1):1
    coeff = [LL, w{ilevel}];
%     LL = fsynthesis(FB, coeff, 2, 2);
    LL = fsynthesis(FB, coeff);
end

y = ifft2(LL);  % change the data back into time domain





end

