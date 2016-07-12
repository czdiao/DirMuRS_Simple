function [ coeff_real ] = getCoeffReal( obj )
%GETCOEFFREAL For TPCTF transform, separate real/imag coefficients, should 
%be saved in obj.coeff_real.
%
%   Currently only works for TPCTF6 filter bank, since only this filter
%   bank has freqfilter2d.index information set.
%
%   obj.coeff_real = obj.getCoeffReal;
%
%Output:
%   coeff_real{1}{ilevel}{iband}:
%       collect all real parts of the coefficients. 16 bands for TPCTF6
%   coeff_real{2}{ilevel}{iband}:
%       imaginary parts of the coefficients. 16 bands for TPCTF6
%   coeff_real{3}:
%       lowpass output at last level
%
%   This function relies on pairmap(N, 2). We only collect real/imag part
%   from the bands indexed by the first column of the pairmap. The second
%   column indexed bands are their complex conjugate.
%
%
%   Chenzhe Diao
%   Jun, 2016
%

if isempty(obj.coeff)
    error('The wavelet coefficients are empty!');
end

coeff = obj.coeff;
coeff_real = cell(1,3);

if isempty(obj.pairmap)
    pairmap = obj.getpairmap;
else
    pairmap = obj.pairmap;
end

nL = obj.nlevel;
nb = size(pairmap, 1);
for j = 1:nL
    coeff_real{1}{j} = cell(1, nb);
    coeff_real{2}{j} = cell(1, nb);
    for ib = 1:nb
        ind = pairmap(ib, 1);
        coeff_real{1}{j}{ib} = real(coeff{j}{ind});
        coeff_real{2}{j}{ib} = imag(coeff{j}{ind});
    end
end

coeff_real{3} = coeff{nL+1};


end

