function [ w ] = fFramelet1d( fdata, J, FfilterBank )
%FFRAMELET1D 1D Framelet Transform in Frequency Domain.
%Input:
%   fdata:
%       1D data in frequency domain.
%   J:
%       level of decompositions.
%   FfilterBank:
%       Frequency Based Filter Bank (freqfilter1d object array).
%
%Output:
%   w:
%       framelet coefficients in frequency domain.
%
%   Author: Chenzhe Diao


NFfilter = length(FfilterBank);
w = cell(1, J+1);

for ilevel = 1:J
    w{ilevel} = cell(1, NFfilter-1);
    for iband = 2:NFfilter
        w{ilevel}{iband-1} = fanalysis(FfilterBank(iband), fdata, 2);
    end
    fdata = fanalysis(FfilterBank(1), fdata, 2);
end
w{J+1} = fdata;



end

