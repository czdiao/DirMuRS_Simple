function w = fanalysis(Ffilter, fdata)
%FANALYSIS 2D Analysis operation in frequency domain.
%Input:
%   Ffilter:
%       filter in frequency domain, freqfilter2d object.
%   fdata:
%       2D data matrix in frequency domain.
%   rate1:
%       downsample rate in dim 1 (along col)
%   rate2:
%       downsample rate in dim 2 (along row)
%
%Output:
%   w:
%       wavelet coefficients in frequency domain.
%
%   Chenzhe
%   Feb, 2016
%

% Convolution
Ffilter.ffilter = conj(Ffilter.ffilter);
w = fconv(Ffilter,fdata);

% Downsample
rate1 = Ffilter.rate;
rate2 = rate1;
w = fdownsample(w, rate1, 1);
w = fdownsample(w, rate2, 2);

w = w*sqrt(rate1*rate2);

end

