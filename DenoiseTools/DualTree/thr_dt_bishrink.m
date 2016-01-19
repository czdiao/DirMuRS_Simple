function W2D_dt_new = thr_dt_bishrink(W2D_dt,Nsig, latent_sigma)
% Bivariate Shrinkage function for Dual Tree CWT type coefficients
%
% Input:
%	W2D_dt:	
%       2D Wavelet Data, in class WaveletData2D, the tranform type
%       should be 'DualTree'. The coefficients should be normalized.
%	Nsig:
%       noise level
%   latent_sigma (optional):
%       local variance of the latent image. If it is not given, we will
%       estimate it by the noisy wavelet coeff data.
%
% Output:
%	W2D_dt_new:
%       denoised coefficients, also saved in WaveletData2D class.
%
%
% Author:   Chenzhe
% Jan, 2016


windowsize  = 7;
I=sqrt(-1);

if nargin==2
    latent_est = true;
else
    latent_est = false;
end

J = W2D_dt.nlevel;
nB = W2D_dt.nband;
coef = W2D_dt.coeff;

for scale = 1:J-1
    for dir = 1:2
        for dir1 = 1:nB
            
            % Noisy complex coefficients
            %Real part
            Y_coef_real = coef{scale}{1}{dir}{dir1};
            % imaginary part
            Y_coef_imag = coef{scale}{2}{dir}{dir1};
            % The corresponding noisy parent coefficients
            %Real part
            Y_parent_real = coef{scale+1}{1}{dir}{dir1};
            % imaginary part
            Y_parent_imag = coef{scale+1}{2}{dir}{dir1};
            % Extend noisy parent matrix to make the matrix size the same as the coefficient matrix.
            Y_parent_real  = expand(Y_parent_real);
            Y_parent_imag   = expand(Y_parent_imag);
                        
            
            % Signal variance estimation
            if latent_est
                Ssig = latent_variance_estimator(Y_coef_real, Nsig, 'local_soft',windowsize);
            else
                Ssig = latent_sigma{scale}{1}{dir}{dir1};
            end
            
            % Threshold value estimation
            T = sqrt(6)*Nsig^2./Ssig;
            
            % Bivariate Shrinkage
            Y_coef = Y_coef_real+I*Y_coef_imag;
            Y_parent = Y_parent_real + I*Y_parent_imag;
            
            Y_coef = bishrink(Y_coef,Y_parent,T);
            coef{scale}{1}{dir}{dir1} = real(Y_coef);
            coef{scale}{2}{dir}{dir1} = imag(Y_coef);
            
        end
    end
end

W2D_dt_new = W2D_dt;
W2D_dt_new.coeff = coef;


end
