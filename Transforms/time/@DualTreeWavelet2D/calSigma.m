function trueSig = calSigma( obj )
%CALSIGMA Calculate the local std of the wavelet coefficients.
%
%Output:
%   trueSig:    store the local variance of the wavelet coeff, in the same
%               data structure as obj.coeff
%
%   Chenzhe
%   Jan 2016

nL = obj.nlevel;
nB = obj.nband;
w = obj.coeff;

trueSig = cell(1, nL);

for scale = 1:nL
    trueSig{scale} = cell(1,2);
    for t1 = 1:2
        trueSig{scale}{t1} = cell(1,2);
        for t2 = 1:2
            trueSig{scale}{t1}{t2} = cell(1, nB);
            for iband = 1:nB
                trueSig{scale}{t1}{t2}{iband} = local_variance(w{scale}{t1}{t2}{iband},7);
            end
        end
    end
end



end

