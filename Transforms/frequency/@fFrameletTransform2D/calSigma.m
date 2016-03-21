function trueSig = calSigma( obj )
%CALSIGMA Calculate the local std of the wavelet coefficients.
%
%Output:
%   trueSig:    store the local variance of the wavelet coeff, in the same
%               data structure as obj.coeff
%
%   Chenzhe
%   Feb, 2016
%

nL = obj.nlevel;
w = obj.coeff;

trueSig = cell(1, nL);

for scale = 1:nL
    nB = length(w{scale});
    trueSig{scale} = cell(1, nB);
    for iband = 1:nB
        trueSig{scale}{iband} = local_variance(w{scale}{iband},7);
    end
end


end

