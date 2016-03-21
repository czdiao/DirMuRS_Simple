function w = fconv(Ffilter, fdata)
%FCONV 2D Convolution of data and filter in frequency domain.
%
%Input:
%   Ffilter:
%       2D Frequency based filter, freqfilter2d object.
%   fdata:
%       2D data (matrix) in frequency domain.
%Output:
%   w:
%       convolution of the filter and data in frequency domain.
%
%   Note:
%       The Ffilter might have a larger sampling rate (more data) than
%       fdata, we will downsample Ffilter before the convolution.
%
%   Chenzhe
%   Feb, 2016
%

[M, N] = size(fdata);
[l1, l2] = size(Ffilter.ffilter);
if mod(l1, M)~=0 || mod(l2, N)~=0
    error('Frequency-based Filter Sampling Rate Does not match the data size!');
else
    rate1 = l1/M;
    rate2 = l2/N;
    Ffilter = filterdownsample(Ffilter, rate1, rate2);
end

w = fdata.*Ffilter.ffilter;



end

