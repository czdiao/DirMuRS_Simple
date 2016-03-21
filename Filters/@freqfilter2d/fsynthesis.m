function x = fsynthesis(FfilterBank, fdatacells)
%FSYNTHESIS 2D Synthesis operation in frequency domain.
%Input:
%   FfilterBank:
%       filter bank in frequency domain, freqfilter2d object array.
%   fdatacells:
%       2D data matrix in frequency domain.
%   rate1:
%       sampling rate in dim 1 (along col)
%   rate2:
%       sampling rate in dim 2 (along row)
%
%Output:
%   x:
%       recoveried signal in frequency domain.
%
%   Chenzhe
%   Feb, 2016
%

NFfilter = length(FfilterBank);
if length(fdatacells)~=NFfilter
    error('Number of filters does not match the number of coeff in synthesis!');
end

sz = size(fdatacells{1});
rate1 = FfilterBank(1).rate;
rate2 = rate1;
sz(1) = sz(1)*rate1;
sz(2) = sz(2)*rate2;

x = zeros(sz);
for i = 1:NFfilter
    if max(abs(fdatacells{i}(:)))>eps
        rate1 = FfilterBank(i).rate;
        rate2 = rate1;
        dataup = fupsample(fdatacells{i}, rate1, 1 ); %upsample the data
        dataup = fupsample(dataup, rate2, 2);
%         x = x + fconv(FfilterBank(i), dataup); % convolution
        tmp = fconv(FfilterBank(i), dataup) * sqrt(rate1*rate2);
        x = x + tmp;
    end
end

% x = x*sqrt(rate1*rate2);



end

