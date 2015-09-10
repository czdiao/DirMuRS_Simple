function [ wt ] = wifft2_dt( wf )
%WIFFT2_DT Summary of this function goes here
%   Detailed explanation goes here

J = length(wf)-1;

wt = wf;
nband = length(wf{1}{1}{1});

for j = 1:J
    for tree1 = 1:2
        for tree2 = 1:2
            for iband = 1:nband
                wt{j}{tree1}{tree2}{iband} = real(ifft2(wt{j}{tree1}{tree2}{iband}));
            end
        end
    end
end




end

