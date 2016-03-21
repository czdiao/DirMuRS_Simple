function W = LocalSoft( obj, Ssig_latent, SigmaN )
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
%   Jan, 2016
%


J = obj.nlevel;
nB = obj.nband;
W = obj.coeff;

for scale = 1:J
    for dir = 1:2
        for d2 = 1:2
            for iband = 1:nB
                
                Y_coef = W{scale}{d2}{dir}{iband};
                % Signal variance estimation
                Ssig = Ssig_latent{scale}{d2}{dir}{iband};
                
                % Threshold value estimation
                T = SigmaN^2./Ssig;
                
                % local soft
                Y_coef = soft(Y_coef,T);
                W{scale}{d2}{dir}{iband} = Y_coef;
                
            end
        end
    end
end




end

