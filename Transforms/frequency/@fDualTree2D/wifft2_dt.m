function [ wt ] = wifft2_dt( wf )
%WIFFT2_DT Perform ifft2 to all the dual tree CWT coefficients.
%
%The original data in time domain is supposed to be all real. So we just
%discard the imaginary part.
%
%   Chenzhe
%   Feb, 2016
%

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

