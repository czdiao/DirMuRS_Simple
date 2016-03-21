function f2 = filterdownsample(ffilter_old, rate1, rate2)
%FILTERDOWNSAMPLE Downsample of the freqfilter2d.
%
%   Note:
%       Ideally speaking (if the filter is short in time domain), this
%       function will output the same filter in time domain.
%       Suppose N=length(ffilter_old), if the filter length in time domain
%       is larger than N/rate, the filter will fold after one period. So
%       this will generate a different filter.
%
%   Chenzhe
%   Feb, 2016
% 

[M, N] = size(ffilter_old.ffilter);
if mod(M, rate1)~=0 || mod(N, rate2)~=0
    error('Wrong Sampling Rate for Frequency Filters!');
end
f2 = ffilter_old;
f2.ffilter = ffilter_old.ffilter(1:rate1:end, 1:rate2:end);






end

