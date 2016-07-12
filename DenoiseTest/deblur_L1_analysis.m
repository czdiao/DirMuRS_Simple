function [ u ] = deblur_L1_analysis( x, ker, blur, Nsig, wavetrans, x_true )
%DEBLUR_L1_ANALYSIS Deblur an image using L1 analysis based model
%
%   This function is implementation of Split Bregman method based on:
%       J.-F. Cai, S. Osher, and Z. Shen. 
%       Split bregman methods and frame based image restoration. Multiscale modeling & simulation, 8(2):337?369, 2009.
%
%   Solving unconstrained analysis based model, see (4.6) in the paper
%
%Input:
%   x:
%       Noisy image
%   ker:
%       Blurring kernel. Should be a matrix with zero position in the
%       middle.
%   blur:
%       Blurring fuction handle:
%       y = blur(x, ker)
%   Nsig:
%       Noise level, standard deviation sigma
%   wavetrans:
%       Of some wavelet transform class. Should be of some subclass of
%       WaveletData2D. Supporting the WaveletData2D interface.
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
% L = length(x); % length of the original image.
% buffer_size = L/2;
% x = symext(x,buffer_size);
% % x_true_ext = symext(x_true, buffer_size);
% ind = buffer_size+1 : buffer_size+L;    % to extract the image
normx = norm(x, 'fro');


% Transform and estimate the latent local std (for thresholding mu)
WT = wavetrans;
WT.coeff = WT.decomposition(x);

% initialization
tol = 1e-3;
maxit = 100;

u = zeros(size(x));
d = WT;
d.coeff = d.decomposition(u);
b = d;
lambda = 0.05;   % choose any number lambda>0
delta = 1;      % choose any number 0<delta<=1

cker=rot90(ker,2);  % kernel corresponding to the transpose of the blur matrix
BTg=blur(x,cker);
eigenP = eigenofP(ker,lambda,x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculation of thresholding level mu

% local soft mu
if isempty(WT.nor)
    WT.nor = WT.CalFilterNorm;
end
% WT.coeff = WT.normcoeff;
% latent_sigma = WT.latentSigma(Nsig, 'local_soft');
% calmu = @(Ssig, nor) (Nsig^2./Ssig).* nor/lambda * 0.3;
% mu = WT.operate_band2(calmu, latent_sigma, WT.nor);

% Cai's mu 1
% mu0 = 0.1;
% wLevel=0.5;
% mu = WT.nor;
% for j = 1:WT.nlevel
%     nB = length(WT.coeff{j});
%     for iB = 1:nB
%         mu{j}{iB} = mu0*wLevel^(j-1)/lambda;
%     end
% end

% Cai's mu 2
% mu0 = 0.3;
% mu = WT.nor;
% for j = 1:WT.nlevel
%     nB = length(WT.coeff{j});
%     for iB = 1:nB
%         mu{j}{iB} = mu0*mu{j}{iB}/lambda;
%     end
% end

% Angular mu, Chenzhe
% % 0.3, 0.5
mu0 = 0.3;
wLevel = 0.5;
K = 6;
mu = WT.nor;
count = 1;
nB = length(WT.coeff{1});
for j = 1:nB/K
    for i = 1:K
        mu{1}{count} = mu0*wLevel^(j-1)*mu{1}{count}/lambda;
        count = count+1;
    end
end




% Wsig = WT.calSigma;
% [nor, blurred_nor] = blurred_frame_norm(WT, cker);
% calSigx = @(Wsig, nor) sqrt(max(Wsig.^2-Nsig^2*nor.^2, eps));
% Sigx = WT.operate_band2(calSigx, Wsig, nor);
% normSig = @(Sigx, blurred_nor) Sigx/blurred_nor;
% Sigx = WT.operate_band2(normSig, Sigx, blurred_nor);
% calmu = @(mu, )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for niter = 1:maxit
    % step 1:   update u
    tmp = reconstruction(d-b);
    
    u = ifft2(fft2(BTg + lambda*tmp)./eigenP);

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
%     v = u(ind,ind);
    v = u;
    PSNR_val = PSNR(v, x_true);
    fprintf('Step %d: \t err = %g,\t PSNR = %g\n', niter, err, PSNR_val);
    
    if err<tol  % error is 0 means the constraint is met, then the optimal sol is found
        break;
    end
end

% Extract the image
% u = u(ind,ind);


end

function eigenP=eigenofP(ker,lambda,x)
% Fourier symbol of ker(-x) \convlv ker(x)+lambda*delta(x)
% x is the original image, to specify the size of the output wanted

[m, n] = size(x);
[nker,mker]=size(ker);
tmp=zeros(m,n);tmp(1:nker,1:mker)=ker;
tmp=circshift(tmp,[-floor(nker/2),-floor(mker/2)]);
eigenP=abs(fft2(tmp)).^2+lambda;

end

function [nor, blurred_nor] = blurred_frame_norm(WT, cker)
% Calculate the norm of the frames and blurred frames


L = 256;
x = zeros(L);
WT.coeff = WT.decomposition(x);
nL = WT.nlevel;

no = 1;
for j = 1:nL
    nB = length(WT.coeff{j});
    for iB = 1:nB
        WT.coeff{j}{iB}(no, no) = 1;
        y = WT.reconstruction;
        y_blur = imfilter(y, cker, 'circular');
        
        nor{j}{iB} = norm(y, 'fro');
        blurred_nor{j}{iB} = norm(y_blur, 'fro');
        
        WT.coeff{j}{iB}(no, no) = 0;
    end
end





end


