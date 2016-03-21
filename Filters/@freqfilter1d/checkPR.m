function checkPR( ffb, rate )
%CHECKPR Check the PR condition for a given frequency filter bank.
%Input:
%   ffb:
%       Frequency filter bank, freqfilter1d array
%   rate:
%       Sampling rate, default is 2
%
%   Chenzhe
%   Feb, 2016
%

if nargin == 1
    rate = 2;
end

N = length(ffb(1).ffilter);
len = length(ffb);

if mod(N, rate)~=0
    error('Wrong Downsampling rate!');
end

e = zeros(rate, N);  % we need to check num=rate conditions

lshift = N/rate;
for iPR = 0:(rate-1)
    ei = zeros(1, N);
    for iFilter = 1:len
        f = ffb(iFilter).ffilter;
        fshift = circshift1d(f, iPR*lshift);
        ei = ei + f.*conj(fshift);
    end
    e(iPR+1, :) = ei;
end

for i = 1:rate
    plot(abs(e(i, :)), '*-');
    hold on;
end

e(1,:) = e(1,:)-1;  % The first condition should be 1
legendInfo = cell(1, rate);
for i = 1:rate  % Calculate and display Error
    err = sprintf('%g', max(abs(e(i,:))));
    legendInfo{i} = ['Condition ' num2str(i) 'Max Error =' err];
end

legend(legendInfo);
title('Check PR condition for Filter Bank in Frequency Domain');
grid on


end

