function [ wt ] = wifft2( wf )
%WIFFT2 Perform ifft2 to all the framelet coefficients.
%
%
%   Chenzhe
%   Feb, 2016
%

J = length(wf)-1;

wt = wf;

for j = 1:J
    nband = length(wt{j});
    for iband = 1:nband
        wt{j}{iband} = ifft2(wt{j}{iband});
    end
end

wt{J+1} = ifft2(wt{J+1});


end

