function W = BiShrink( obj, Ssig_latent, SigmaN )
%BISHRINK Bivariate Shrinkage function of the DT-CWT type coefficients.
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
%       For this complex transform, the shrinkage is performed on the
%       magnitude of the complex wavelet coefficients. Although the latent
%       local sigma is calculated based on the real part of the signal.
%
%   Chenzhe
%   Jan, 2016
%

I=sqrt(-1);

J = obj.nlevel;
nB = obj.nband;
W = obj.coeff;

% we can only do nlevel-1 scales, since the last scale has no parent
for scale = 1:J-1
    for dir = 1:2
        for dir1 = 1:nB
            
            % Noisy complex coefficients
            %Real part
            Y_coef_real = W{scale}{1}{dir}{dir1};
            % imaginary part
            Y_coef_imag = W{scale}{2}{dir}{dir1};
            % The corresponding noisy parent coefficients
            %Real part
            Y_parent_real = W{scale+1}{1}{dir}{dir1};
            % imaginary part
            Y_parent_imag = W{scale+1}{2}{dir}{dir1};
            % Extend noisy parent matrix to make the matrix size the same as the coefficient matrix.
            Y_parent_real  = expand(Y_parent_real);
            Y_parent_imag   = expand(Y_parent_imag);
                        
            
            % Signal variance estimation
            Ssig = Ssig_latent{scale}{1}{dir}{dir1};
            
            % Threshold value
            T = sqrt(6)*SigmaN^2./Ssig;
            
            % Bivariate Shrinkage
            Y_coef = Y_coef_real+I*Y_coef_imag;
            Y_parent = Y_parent_real + I*Y_parent_imag;
            
            Y_coef = bishrink(Y_coef,Y_parent,T);
            W{scale}{1}{dir}{dir1} = real(Y_coef);
            W{scale}{2}{dir}{dir1} = imag(Y_coef);
            
        end
    end
end





end

