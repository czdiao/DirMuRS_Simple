function f2 = filterdownsample(ffilter_old, rate)
%FILTERDOWNSAMPLE Downsample the Frequency based filter.
% rate is the downsampling rate.
%
%   Note:
%       Ideally speaking (if the filter is short in time domain), this
%       function will output the same filter in time domain.
%       Suppose N=length(ffilter_old), if the filter length in time domain
%       is larger than N/rate, the output filter will fold after one
%       period. So this will generate a different filter.
%
%   Chenzhe
%   July, 2015
%
%   Note:
%       This corresponds to downsample of the frequency domain sequence. It
%       is different from the downsample in time domain.
%
%   Chenzhe
%   Mar, 2016
%

len = length(ffilter_old.ffilter);
if mod(len, rate)~=0
    error('Wrong Sampling Rate for Frequency Filters!');
end
f2 = freqfilter1d;
f2.ffilter = ffilter_old.ffilter(1:rate:end);
%             f2.ffilter = downsample(ffilter_old.ffilter, rate);


end

