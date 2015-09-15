function [ fdata ] = ifFramelet1d( w, J, FfilterBank )
%IFFRAMELET1D Inverse of Frequency Based Framelet Transform in 1D.
%Input:
%   w:
%       Framelet coeff in frequency domain. Cell array. w{ilevel}{iband},
%       (ilevel=1:J). w{J+1} is the output of last level lowpass filter.
%   J:
%       Level of framelet decompositions.
%   FfilterBank:
%       Frequency based filter bank. (freqfilter1d array).
%Output:
%   fdata:
%       synthesised data in frequency domain.
%
%   Author: Chenzhe Diao

LL = w{J+1};

for ilevel = J:(-1):1
    coeff = [LL, w{ilevel}];
    LL = fsynthesis(FfilterBank, coeff, 2);
end

fdata = LL;

end

