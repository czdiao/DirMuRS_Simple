function [ y ] = reconstruction_undecimated( obj )
%RECONSTRUCTION_UNDECIMATED Undecimated Reconstruction of TP-CTF 2D transform
%
%
%   The transform is implemented using 2d filter freqfilter2d.
%   Undecimated version.
%
%
%   Chenzhe
%   Jun, 2016
%

FB = obj.FilterBank2D;
for i = 1:length(FB)
    FB(i).rate = 1;
end

w = obj.coeff;
w = obj.wfft2(w);   % Change the coeff into frequency domain
J = obj.nlevel;

LL = w{J+1};

for ilevel = J:(-1):1
    
    % For undecimated transform, the filters used at each level
    rate = 2^(ilevel-1);
    FB_j = FB.timeupsample(rate, rate);
    
    coeff = [LL, w{ilevel}];
    LL = fsynthesis(FB_j, coeff);
end

y = ifft2(LL);  % change the data back into time domain


end

