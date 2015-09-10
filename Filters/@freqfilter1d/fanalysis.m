function w = fanalysis(Ffilter, fdata, rate, dim)
%FANALYSIS Analysis operation in frequency domain.
%Input:
%   Ffilter:
%       freqfilter1d object. 1d Frequency based filter.
%   fdata:
%       data in frequency domain. Could be 1 to 3 dimensional.
%   rate:
%       downsampling rate for analysis operation.
%   dim:
%       integer. Along which dimension to perform the analysis
%       operation. Could be omitted for vector fdata.
%
%Output:
%   w:
%       Wavelet coefficients in frequency domain.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

% set dim for vector fdata
if isrow(fdata)
    dim = 2;
elseif iscolumn(fdata)
    dim = 1;
end

% Convolution
Ffilter.ffilter = conj(Ffilter.ffilter);
w = fconv(Ffilter,fdata, dim);

% Downsample
w = fdownsample(w, rate, dim);

w = w*sqrt(rate);

end % fanalysis

