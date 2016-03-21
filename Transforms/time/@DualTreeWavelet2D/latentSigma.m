function Sig_est  = latentSigma(obj, sigmaN, opt)
%LATENTSIGMA Estimator of the latent local std of the wavelet coeff.
%
%Input:
%   sigmaN:
%       noise variance level.
%   opt:
%       estimator choice. See latent_variance_estimator function in
%       Utilities/
%
%Ouput:
%   Sig_est:
%       Estimation of the latent local std of the wavelet coeff. Saved
%       each scale, band, in the same data structue as obj.coeff
%
%   Chenzhe
%   Jan, 2016
%

nL = obj.nlevel;
nB = obj.nband;
w = obj.coeff;

Sig_est = cell(1, nL);

for scale = 1:nL
    Sig_est{scale} = cell(1,2);
    for t1 = 1:2
        Sig_est{scale}{t1} = cell(1,2);
        for t2 = 1:2
            Sig_est{scale}{t1}{t2} = cell(1, nB);
            for iband = 1:nB
                Sig_est{scale}{t1}{t2}{iband} =...
                    latent_variance_estimator(w{scale}{t1}{t2}{iband}, sigmaN, opt, 7);
            end
        end
    end
end






end

