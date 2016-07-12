function W = LocalSoft(obj, Ssig_latent, SigmaN)
%LOCALSOFT Local Soft-thresholding.
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
%       This thresholding is applied on real/imaginary part respectively.
%       We still don't know how to perform the thresholding on the
%       complex magnitude.
%
%   Chenzhe Diao
%   Feb, 2016
%


J = obj.nlevel;
W = obj.coeff;

for scale = 1:J
    nB = length(W{scale});
    for iband = 1:nB
        
        Y_coef = W{scale}{iband};
        % Signal variance estimation
        Ssig = Ssig_latent{scale}{iband};
        
        % Threshold value estimation
        T = SigmaN^2./Ssig;
%         T = SigmaN^2*(1+0.007*SigmaN)./Ssig;    % only for test
        
        % local soft
        Y_coef = soft(Y_coef,T);
        W{scale}{iband} = Y_coef;
        
    end
end


end

