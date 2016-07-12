function [ u ] = denoise_L1_analysis( x, Nsig, wavetrans, opt, x_true )
%DENOISE_L1_ANALYSIS Denoise an image using L1 analysis based model
%
%   This function is implementation of Split Bregman method based on:
%       J.-F. Cai, S. Osher, and Z. Shen. 
%       Split bregman methods and frame based image restoration. Multiscale modeling & simulation, 8(2):337?369, 2009.
%
%   Since the paper is based on deblur problem, we just use kernel A = I
%
%Input:
%   x:
%       Noisy image
%   Nsig:
%       Noise level, standard deviation sigma
%   wavetrans:
%       Of some wavelet transform class. Should be of some subclass of
%       WaveletData2D. Supporting the WaveletData2D interface.
%   opt:
%       'unconstrained':
%           Solving unconstrained analysis based model, see (4.6) in the paper
%       'constrained':  (not implemented yet)
%           Solving constrained analysis based model, see (4.8) in the paper
%   x_true:
%       latent true image, for calculation of the true latent local sigma
%       and PSNR in each step iteration. This is for testing purpose only.
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


tol = 1e-3;
maxit = 100;

switch opt
    case 'unconstrained'
        % initialization
        u = zeros(size(x));
        d = WT;
        d.coeff = d.decomposition(u);
        b = d;
        lambda = 0.5;   % choose any number lambda>0
        delta = 1;      % choose any number 0<delta<=1
        
        calmu = @(Ssig, nor) (Nsig^2./Ssig).* nor/lambda;
        mu = WT.operate_band2(calmu, latent_sigma, WT.nor);
        
        for niter = 1:maxit
            % step 1:   update u
            tmp = reconstruction(d-b);
            u = (x + lambda*tmp)/(1+lambda);
            % step 2:   update d
            WT.coeff = WT.decomposition(u);
            d = WT + b;
            d.coeff = d.SoftThresh(mu);     % need to specify mu
            % step 3:   update b
            WTerr = WT - d;     % WT is the decomposition of u_{k+1}
            b = b + delta.* WTerr;
            
            % calculate err, print PSNR
            err = WTerr.norm(2)/normx;    % the l2 norm of the err in wavelet domain
            
            % PSNR
            % Extract the image
            v = u(ind,ind);
            PSNR_val = PSNR(v, x_true);
            fprintf('Step %d:\t err = %g,\t PSNR = %g\n', niter, err, PSNR_val);
            
            if err<tol  % error is 0 means the constraint is met, then the optimal sol is found
                break;
            end
        end
        
        
    case 'constrained'
        error('Not implemented yet!');
    otherwise
        error('Unknown algorithm!');
end



% Extract the image
% ind = buffer_size+1 : buffer_size+L;
u = u(ind,ind);


end


