function [dcoef] = BLSGSM9(coef,noise,logz,params)
%
% This code implements Mixtures of Gaussian Scale Mixture (MGSM) for 
% UNDECIMATED Tensor product complex tight framelets (TP-CTF) with 
% precalculated noise covariance matrix (C_w) in EACH band.
% EM procedure is applied.
%
% Inputs: 
%       coef: either real or imaginary part of noisy coef in ONE band
%       C_w : either real or imaginary part of noise cov matrix in ONE
%               band
%       logz: 13 samples of multiplier z in log
%       params: denoising params
%              params.block = [5 5]; % block size
%              params.optim = 1;
%              params.parent = 0; % use parent or not (1/0)
%              params.covariance = 1;
% Outputs:
%       dcoef: denoised coefficients in ONE band
% 
%% 
block = params.block;
prnt  = params.parent;
[nv,nh,nb] = size(coef); 
% dcoef = zeros(size(coef));
K = 8;   % MPGSM componets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the coeff covariance C_x
% Discard the outer coeffs for the reference 
% (central) coeffs to avoid boundary effects)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interior_mask = makeInteriorMask([nv nh],floor(max(block)/2));
patches = packVecPatches(coef,block);
norpatch = patches(:,interior_mask(:)); % picking up columns

noise_patches = packVecPatches(noise,block);
noise_norpatch = noise_patches(:,interior_mask(:)); % picking up columns

% C_u for initialization
C_y = norpatch*norpatch'/size(norpatch,2);
C_w = noise_norpatch*noise_norpatch'/size(noise_norpatch,2);

C_u = fixNegEigs(C_y - C_w);
centerind = floor((prod(block)+1)/2);

%% Initialization and EM-like iteration
% choice 1
% model.mu = zeros(prod(block),K);
% model.weight = ones(1,K)/K;
% for k = 1:K
%     model.Sigma(:,:,k) = C_u*2*k/(K+1) + C_w;
% end
% [label, model, ~] = emgm2(norpatch, model); % initialization by model

% mask = reshape(label,[sqrt(size(norpatch,2)) sqrt(size(norpatch,2))]);
% figure,imagesc(mask),axis image
% keyboard;

% choice 2
model.mu = zeros(K,prod(block));
model.weight = ones(1,K)/K;
for k = 1:K
    model.Sigma(:,:,k) = C_u*2*k/(K+1) + C_w;
end
fprintf('EM-like for Gaussian mixture: running ... \n');
obj = gmdistribution.fit(norpatch',K,'Start',model,'Regularize', 1e-5);

model.Sigma = obj.Sigma;
model.weight = obj.PComponents;
% pause;
%keyboard;
%% Use PCA to calculate the project bases

for k = 1:length(model.weight)

    C_t = model.Sigma(:,:,k);
    C_x = fixNegEigs(C_t - C_w);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate wiener filters for covariance,will use
    % invYcov, sqrtdetYcov, and wienerfilt
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Nz = length(logz);
    for kz = 1:Nz
        z = exp(logz(kz));
        invYcov{kz} = inv(z*C_x + C_w);
        sqrtdetYcov(kz) = sqrt(det(z*C_x + C_w));
        
        % wiener filters for covariance
        wftotal = z*C_x/(z*C_x + C_w);
        wienerfilt{kz} = wftotal(centerind,:);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % main loop - integrate over logz
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     patches = packVecPatches(coef,block);
    Npatches = size(patches,2);
    xhat_sum_p = zeros(1,Npatches);
    norm = zeros(1,Npatches);
    
    fprintf('Denoising (Nz=%g) ',Nz);
    for kz = 1:Nz
        fprintf(' %g',kz);
        wienerfilt_tmp = wienerfilt{kz};
        xhat_p = wienerfilt_tmp*patches;
        invYcov_tmp = invYcov{kz};
        quadform_p = -(1/2)*sum(patches.*(invYcov_tmp*patches));
        
        % w is proportional to p(y|z)
        w = (1/Nz)*(1/sqrtdetYcov(kz)).*exp(quadform_p);
        w = w(:)';
        xhat_sum_p = xhat_sum_p + w.*xhat_p;
        norm = norm + w;
    end
    fprintf('\n');
    norm(find(norm==0)) = 1;
    xhat(:,k) = xhat_sum_p./norm; % xhat(:,k) for component k

    logGauss(:,k) = loggausspdf(patches,C_t);
end

logWeightGauss = bsxfun(@plus,logGauss,log(model.weight));
logSum = logsumexp(logWeightGauss,2);
logR = bsxfun(@minus,logWeightGauss,logSum);
R = exp(logR);

dcoef = sum(xhat.*R,2);
% dcoef = sum(bsxfun(@times, xhat, model.weight),2);
if any(isnan(vec(dcoef)))
    fprintf('NaN is detected!\n');
end
dcoef = reshape(dcoef,size(coef));

end