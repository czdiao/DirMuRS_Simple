function W = BiShrink(obj, Ssig_latent, SigmaN)
%BISHRINK Bivariate Shrinkage function of the framelet type coefficients.
%
%   T = sqrt(3)*(y/sqrt(y^2+y_p^2))*(SigmaN^2/Ssig_latent)
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
%       For complex transform, the shrinkage is performed on the
%       magnitude of the complex wavelet coefficients. The latent local
%       sigma is also calculated based on the magnitude of the
%       coefficients.
%
%   Chenzhe
%   Feb, 2016
%

J = obj.nlevel;
W = obj.coeff;

% we can only do nlevel-1 scales, since the last scale has no parent
for scale = 1:J-1
    nB = length(W{scale});
    
    for dir1 = 1:nB
        
        % Signal variance estimation
        Ssig = Ssig_latent{scale}{dir1};
        
        % Threshold value
        T = sqrt(3)*SigmaN^2./Ssig;
        
        % Bivariate Shrinkage
        Y_coef = W{scale}{dir1};
        Y_parent = W{scale+1}{dir1};
        Y_parent = expand(Y_parent);
        
        Y_coef = bishrink(Y_coef,Y_parent,T);
        W{scale}{dir1} = Y_coef;
        
    end
end



end

