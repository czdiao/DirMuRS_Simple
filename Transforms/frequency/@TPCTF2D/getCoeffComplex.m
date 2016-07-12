function [ coeff ] = getCoeffComplex( obj )
%GETCOEFFCOMPLEX For TPCTF transform, combine real/imaginary part of the
%coefficients to get complex coefficients saved in obj.coeff.
%
%   This function is the inverse of getCoeffReal
%
%   obj.coeff = obj.getCoeffComplex
%
%   Chenzhe Diao
%   Jun, 2016
%

if isempty(obj.pairmap)
    pairmap = obj.getpairmap;
else
    pairmap = obj.pairmap;
end

coeff_real = obj.coeff_real{1};
coeff_imag = obj.coeff_real{2};
coeff_lowpass = obj.coeff_real{3};


nL = obj.nlevel;
coeff = cell(1, nL+1);

Nrow = size(pairmap, 1);
nb = Nrow*2;
for j = 1:nL
    coeff{j} = cell(1, nb);
    for row = 1:Nrow
        ind1 = pairmap(row, 1);
        ind2 = pairmap(row, 2);
        coeff{j}{ind1} = coeff_real{j}{row} + sqrt(-1)* coeff_imag{j}{row};
        coeff{j}{ind2} = coeff_real{j}{row} - sqrt(-1)* coeff_imag{j}{row};
    end
end

coeff{nL+1} = coeff_lowpass;


end

