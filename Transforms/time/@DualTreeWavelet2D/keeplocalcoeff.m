function [ coeff ] = keeplocalcoeff( obj, Ind )
%KEEPLOCALCOEFF Keep the wavelet coeff corresponding to the specific
%pixel location.
%Input:
%   Ind:
%       Index Matrix, of the same size as the original image. This should
%       be logical matrix (0-1 type). 1 indicate all wavelet coeff
%       coresponding to this pixel location would be kept.
%Output:
%   coeff:
%       Wavelet coefficients. Only keep the original coeff at specific
%       locations.
%
%   Chenzhe
%   Feb, 2016
%

coeff = obj.coeff;
nL = obj.nlevel;
nB = obj.nband;

for il = 1:nL
    Ind = ind_down2(Ind);
    for d1 = 1:2
        for d2 = 1:2
            for ib = 1:nB
                coeff{il}{d1}{d2}{ib} = coeff{il}{d1}{d2}{ib}.* Ind;
            end
        end
    end
end


Ind = ind_down2(Ind);
for d1 = 1:2
    for d2 = 1:2
        coeff{nL+1}{d1}{d2} = coeff{nL+1}{d1}{d2}.* Ind;
    end
end




end

function indnew = ind_down2(ind)
i1 = ind(1:2:end-1, :);
i2 = ind(2:2:end, :);
ind = i1 | i2;

i1 = ind(:, 1:2:end-1);
i2 = ind(:, 2:2:end);

indnew = i1 | i2;

end