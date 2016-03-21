function fhi = fCQF(flow)
%FCQF Generate highpass from lowpass by CQF pairs in Freq domain.
%
%   Chenzhe
%   July, 2015
%

len = length(flow.ffilter);
if mod(len, 2)~=0
    error('Cannot Generate Highpass filter from lowpass!');
end

I = sqrt(-1);
theta = 0:1/len:(len-1)/len;
theta = -theta*2*pi*I;

c = exp(theta);
f = conj(fftshift(flow.ffilter));
fhi = freqfilter1d;
fhi.ffilter = c.*f;

end




end

