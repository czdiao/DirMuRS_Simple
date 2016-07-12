function  f2  = timeupsample( ffilter_old, rate1, rate2 )
%TIMEUPSAMPLE Unsample of the filter in time domain.
%
%   Generate a new freqfilter2d object f2. f2 is rate1*rate2 times larger
%   in size. It corresponds to a time domain upsampling of the filter.
%   To avoid size overflow, we make a frequency domain downsample
%   afterwards. So the output filters are in the same size as the original
%   in frequency domain.
%
%   FIXME: Need to be tested
%
%   Chenzhe Diao
%   Jun, 2016
%

f2 = ffilter_old;

% freq domain downsample, output the same filters, shorter in freq domain, 
% folding in time domain.
f2 = f2.filterdownsample(rate1, rate2);     

len = length(ffilter_old);
for i = 1:len
    f2(i).ffilter = fupsample(f2(i).ffilter, rate1, 1);
    f2(i).ffilter = fupsample(f2(i).ffilter, rate2, 2);
end




end

