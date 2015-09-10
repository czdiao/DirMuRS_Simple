function [ wf ] = wfft2_dt( wt )
%WFFT2_DT Summary of this function goes here
%   Detailed explanation goes here

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

