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

len = length(ffilter_old);
f2 = ffilter_old;

for i = 1:len
    [M, N] = size(ffilter_old(i).ffilter);
    if mod(M, rate1)~=0 || mod(N, rate2)~=0
        error('Wrong Sampling Rate for Frequency Filters!');
    end
    f2(i).ffilter = ffilter_old(i).ffilter(1:rate1:end, 1:rate2:end);
end





end

