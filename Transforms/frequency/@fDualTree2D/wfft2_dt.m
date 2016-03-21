function [ wf ] = wfft2_dt( wt )
%WFFT2_DT Perform fft2 to all the dual tree CWT coefficients.
%
%The output is still in the same data structure as wt
%
%   Chenzhe
%   Feb, 2016
%


J = length(wt)-1;

wf = wt;
nband = length(wf{1}{1}{1});

for j = 1:J
    for tree1 = 1:2
        for tree2 = 1:2
            for iband = 1:nband
                if max(abs(wf{j}{tree1}{tree2}{iband}(:)))>eps
                    wf{j}{tree1}{tree2}{iband} = fft2(wf{j}{tree1}{tree2}{iband});
                end
            end
        end
    end
end




end

