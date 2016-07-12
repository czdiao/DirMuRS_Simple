function  Sig_est = latentSigma_unnormalize(obj, sigmaN, opt)
%LATENTSIGMA_UNNORMALIZE Estimator of the latent local std of the framelet coeff.
%
%   This is the unnormalized version. The obj.coeff is not normalized. So
%   the actual noise level in each band should be:
%   sigmaN*nor{scale}{iband}, where nor is the norm of the filter in each
%   band.
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
%   Jun, 2016
%

nL = obj.nlevel;
w = obj.coeff;
nor = obj.nor;  % the norm of the filter in each scale, each band

Sig_est = cell(1, nL);

for scale = 1:nL
    nB = length(w{scale});
    Sig_est{scale} = cell(1, nB);
    for iband = 1:nB
        Sig_est{scale}{iband} =...
            latent_variance_estimator(w{scale}{iband}, sigmaN*nor{scale}{iband}, opt, 7);
    end
end



end

