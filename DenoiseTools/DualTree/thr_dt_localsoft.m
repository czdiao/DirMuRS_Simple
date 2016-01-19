function W2D_dt_new = thr_dt_localsoft(W2D_dt,Nsig, latent_sigma)
% Local Soft Shrinkage function for Dual Tree CWT type coefficients
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
%   Note:
%       This thresholding is applied on real/imaginary part respectively.
%       We still don't know how to perform the thresholding on the
%       magnitude.
%
% Author:   Chenzhe
% Jan, 2016

windowsize  = 7;

if nargin==2
    latent_est = true;
else
    latent_est = false;
end

J = W2D_dt.nlevel;
nB = W2D_dt.nband;
coef = W2D_dt.coeff;

for scale = 1:J
    for dir = 1:2
        for d2 = 1:2
            for iband = 1:nB
                
                Y_coef = coef{scale}{d2}{dir}{iband};
                % Signal variance estimation
                if latent_est
                    Ssig = latent_variance_estimator(Y_coef, Nsig, 'local_soft',windowsize);
                else
                    Ssig = latent_sigma{scale}{d2}{dir}{iband};
                end
                
                % Threshold value estimation
                T = Nsig^2./Ssig;
                
                % local soft
                Y_coef = soft(Y_coef,T);
                coef{scale}{d2}{dir}{iband} = Y_coef;
                
            end
        end
    end
end

W2D_dt_new = W2D_dt;
W2D_dt_new.coeff = coef;


end
