function checkPR( ffb, rate )
%CHECKPR Check the PR condition for a given 2d frequency filter bank.
%Input:
%   ffb:
%       Frequency filter bank, freqfilter2d array
%   rate:
%       Sampling rate, default is 2
%
%
%   Currently only works for rate=2 case.
%
%   Chenzhe
%   Feb, 2016
%

if nargin == 1
    rate = 2;
end

[N1, N2] = size(ffb(1).ffilter);
len = length(ffb);

if (mod(N1, rate)~=0) || (mod(N2, rate)~=0)
    error('Wrong Downsampling rate!');
end

% e = zeros(rate^2, N);  % we need to check num=rate^2 conditions

figure;
lshift1 = N1/rate;
lshift2 = N2/rate;
isFirst = true;
legendInfo = cell(1, rate^2);   % we need to check num=rate^2 conditions
count = 1;

for iPR1 = 0:(rate-1)
    for iPR2 = 0:(rate-1)
        ei = zeros(N1, N2);
        for iFilter = 1:len
            f = ffb(iFilter).ffilter;
            fshift = circshift2d(f, iPR1*lshift1, iPR2*lshift2);
            ei = ei + f.*conj(fshift);
        end
        if isFirst
            ei = ei-1;
            isFirst = false;
        end
        plot(abs(ei(:)), '*-');
        hold on;
        err = sprintf('%g', max(abs(ei(:))));
        legendInfo{count} = ['Condition ' num2str(count) ': Max Error =' err];
        count = count+1;
    end
end



legend(legendInfo);
title('Check PR condition for Filter Bank in Frequency Domain');
grid on



end

