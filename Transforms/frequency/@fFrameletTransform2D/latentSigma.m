function Sig_est = latentSigma(obj, sigmaN, opt)
%LATENTSIGMA Estimator of the latent local std of the framelet coeff.
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
%   Feb, 2016
%

nL = obj.nlevel;
w = obj.coeff;

Sig_est = cell(1, nL);

for scale = 1:nL
    nB = length(w{scale});
    Sig_est{scale} = cell(1, nB);
    for iband = 1:nB
        Sig_est{scale}{iband} =...
            latent_variance_estimator(w{scale}{iband}, sigmaN, opt, 7);
    end
end




end

