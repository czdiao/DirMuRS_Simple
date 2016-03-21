function v = getlocalcoeff(obj,i, j)
%GETLOCALCOEFF To find all the wavelet coefficients corresponding to
%position (i,j) in the original image
%
%Output:
%   v:
%       Matrix of size nlevel*(4nband), containing all the wavelet
%       coefficients (output of hipass filter) at one image position.
%
%   Chenzhe
%   Jan, 2016

nL = obj.nlevel;
nB = obj.nband;
w = obj.coeff;
v = zeros(nL, 4*nB);
ii = i;
jj = j;
for ilevel = 1:nL
    ii = ceil(ii/2);
    jj = ceil(jj/2);
    count = 1;
    for d1 = 1:2
        for d2 = 1:2
            for iband = 1:nB
                v(ilevel, count) = w{ilevel}{d2}{d1}{iband}(ii, jj);
                count = count+1;
            end
        end
    end
end

end
