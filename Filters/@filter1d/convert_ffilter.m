function ff1d = convert_ffilter(tfilters, N)
%CONVERT_FFILTER Convert time domain filter filter1d objects to frequency 
%domain filter freqfilter1d.
%
%   Input N is the frequency sampling rate.
%   Works for filter bank also.
%
%   Chenzhe
%

len = length(tfilters);
ff1d(len) = freqfilter1d;
for i = 1:len
    if nargin >=2
        num_zeros = N-length(tfilters(i).filter);
    else
        num_zeros = 0;
    end
    ff = [tfilters(i).filter, zeros(1,num_zeros)];
    ff = circshift2d(ff, 0, tfilters(i).start_pt);
    ff = fft(ff);
    ff1d(i).ffilter = ff;
end

end
