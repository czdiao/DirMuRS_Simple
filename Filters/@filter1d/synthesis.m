function x = synthesis(FilterBank, datacells, rate, dim)
%SYNTHESIS Time domain Synthesis Operation.
%       1)  x = synthesis(FilterBank, datacells, rate, dim)
%       2)  x = synthesis(FilterBank, vectorcells, rate)
%Input:
%   FilterBank:
%       filter1d array. Time domain filter bank for synthesis operation.
%   datacells:
%       Cell array of data. Each cell contains data in each band.
%   rate:
%       Upsampling rate in synthesis operation.
%   dim:
%       Dimension along which to perform synthesis operation.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015




if isrow(datacells{1})
    dim = 2;
elseif iscolumn(datacells{1})
    dim = 1;
end

Nfilters = length(FilterBank);
if length(datacells)~=Nfilters
    error('Number of filters does not match the number of coeff in synthesis!');
end

sz = size(datacells{1});
sz(dim) = sz(dim)*rate;
x = zeros(sz);

for i = 1:Nfilters
    if max(abs(datacells{i}(:)))>eps     % To save time in calculating the filter norms
        dataup = tupsample(datacells{i}, rate, dim ); %upsample the data
        x = x + tconv(FilterBank(i), dataup, dim);
    end
end
x = x*sqrt(rate);





end

