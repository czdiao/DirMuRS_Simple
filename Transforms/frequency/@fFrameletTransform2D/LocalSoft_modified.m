function W = LocalSoft_modified(obj, Ssig_latent, SigmaN, C)
%LOCALSOFT_MODIFIED Modified Local Soft-thresholding.
%
%   This is the unnormalized version. The obj.coeff is not normalized. So
%   the actual noise level in each band should be:
%   sigmaN*nor{scale}{iband}, where nor is the norm of the filter in each
%   band. Modified by multipying a factor C.
%
%   The thresholding value is set according to Vetterli's paper.
%       T = SigmaN^2/Ssig
%
% Input:
%   Ssig_latent:
%       local variance of the latent image. Could be calculated by:
%       calSigma() or latentSigma() function defined in this class.
%	SigmaN:
%       noise level
%
% Output:
%	W:
%       denoised coefficients.
%
%   Note:
%       This thresholding is applied on complex magnitude for complex
%       wavelet coefficients.
%
%   Chenzhe Diao
%   Jun, 2016
%

J = obj.nlevel;
W = obj.coeff;
nor = obj.nor;

for scale = 1:J
    nB = length(W{scale});
    for iband = 1:nB
        
        Y_coef = W{scale}{iband};
        % Signal variance estimation
        Ssig = Ssig_latent{scale}{iband};
        normb = nor{scale}{iband};
        
        % Threshold value estimation
        T = (SigmaN * normb)^2./Ssig * C{scale}{iband};
        
        % local soft
        Y_coef = soft(Y_coef,T);
        W{scale}{iband} = Y_coef;
        
    end
end


end

