function x = fsynthesis(FfilterBank, fdatacells, rate, dim )
%FSYNTHESIS Synthesis operation in frequency domain.
%Input:
%   FfilterBank:
%       Frequency based filter bank. freqfilter1d objects array.
%   fdatacells:
%       Wavelet coeffs in frequency domain. Store the coeffs of
%       each band (corresponding to each Ffilter) in a cell array.
%       length(fdatacells) = length(FfilterBank)
%       The data could be 1D/2D/3D.
%   rate:
%       sampling rate. Normally use 2 for dyadic wavelets.
%   dim:
%       along which dim to perform the operation. Could be
%       omitted for vector fdata(row/col array).
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

% set dim for vector fdata
if isrow(fdatacells{1})
    dim = 2;
elseif iscolumn(fdatacells{1})
    dim = 1;
end

NFfilter = length(FfilterBank);
if length(fdatacells)~=NFfilter
    error('Number of filters does not match the number of coeff in synthesis!');
end

sz = size(fdatacells{1});
sz(dim) = sz(dim)*rate;
x = zeros(sz);
for i = 1:NFfilter
    if max(abs(fdatacells{i}(:)))>eps
        dataup = fupsample(fdatacells{i}, rate, dim ); %upsample the data
        x = x + fconv(FfilterBank(i), dataup, dim); % convolution
    end
end

x = x*sqrt(2);

end % fsynthesis
