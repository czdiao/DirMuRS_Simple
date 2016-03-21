function [ wf ] = wfft2( wt )
%WFFT2 Perform fft2 to all the framelet coefficients.
%
%The output is still in the same data structure as wt
%
%   Chenzhe
%   Feb, 2016
%


J = length(wt)-1;

wf = wt;

for j = 1:J
    nband = length(wf{j});
    for iband = 1:nband
        if max(abs(wf{j}{iband}(:)))>eps
            wf{j}{iband} = fft2(wf{j}{iband});
        end
    end
end

if max(abs(wf{J+1}(:)))>eps
    wf{J+1} = fft2(wf{J+1});
end


end

