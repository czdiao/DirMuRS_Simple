function tfilters = convert_tfilter(ffilters)
%CONVERT_TFILTER Convert frequency domain freqfilter1d filter bank into
%time domain filter1d filter bank.
%
%
%   Chenzhe
%   Feb, 2016
%

len = length(ffilters);
tfilters(len) = filter1d;
for i = 1:len
    tfilters(i).filter = ifft(ffilters(i).ffilter);
    tfilters(i).start_pt = 0;
end





end

