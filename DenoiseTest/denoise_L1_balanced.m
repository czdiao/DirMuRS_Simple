function [ u ] = denoise_L1_balanced( x, Nsig, wavetrans, x_true )
%DENOISE_L1_BALANCED Denoise an image using L1 analysis based model
%
%
%
%
%
%   Chenzhe
%   April, 2016
%

% symmetric extension, to reduce boundary effects
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);
% x_true_ext = symext(x_true, buffer_size);
ind = buffer_size+1 : buffer_size+L;    % to extract the image

% Transform and estimate the latent local std (for thresholding mu)
WT = wavetrans;
if isempty(WT.nor)
    WT.nor = WT.CalFilterNorm;
end
WT.coeff = WT.decomposition(x);
WT.coeff = WT.normcoeff;
latent_sigma = WT.latentSigma(Nsig, 'local_soft_m4');

calmu = @(Ssig, nor) (Nsig^2./Ssig).* nor;
mu = WT.operate_band2(calmu, latent_sigma, WT.nor); % thresholding value


tol = 1e-3;
maxit = 100;
u = x;

kappa = 1;

WTtmp = WT;
WTtmp2 = WT;
for niter = 1:maxit
    WTtmp.coeff = WTtmp.decomposition(x-u);
    
    WTtmp2.coeff = WT.coeff;
    y = WTtmp2.reconstruction;
    WTtmp2.coeff = WTtmp2.decomposition(y);
    WTtmp2 = WT - WTtmp2;
    
    WT = WT - kappa.*WTtmp2 + WTtmp;
    WT.coeff = WT.SoftThresh(mu);
    
    u_old = u;
    u = WT.reconstruction;
    err = norm(u-u_old, 'fro');
    
    v = u(ind,ind);
    PSNR_val = PSNR(v, x_true);
    fprintf('Step %d:\t err = %g,\t PSNR = %g\n', niter, err, PSNR_val);
    
    if err<tol  % error is 0 means the constraint is met, then the optimal sol is found
        break;
    end
    
end

% Extract the image
% ind = buffer_size+1 : buffer_size+L;
u = u(ind,ind);




end

