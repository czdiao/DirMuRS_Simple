function [dcoef] = BLSGSM7(coef,C_w,logz,params)
%
% This code implements Mixtures of projected Gaussian Scale Mixture (MPGSM)
% for Tensor product complex tight framelets (TP-CTF) with 
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
K = 8;   % MPGSM componets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the coeff covariance C_x
% Discard the outer coeffs for the reference 
% (central) coeffs to avoid boundary effects)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interior_mask = makeInteriorMask([nv nh],floor(max(block)/2));
patches = packVecPatches(coef,block);
norpatch = patches(:,interior_mask(:)); % picking up columns
% C_u for initialization
C_y = norpatch*norpatch'/size(norpatch,2);
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

%% Use PCA to calculate the project bases

for k = 1:length(model.weight)

    [~,S,Ve] = svd(model.Sigma(:,:,k)); % NOTE: model.Sigma(:,:,k) = Ve*S*Ve';
    q = 1;
    while trace(S(1:q,1:q))/trace(S) < 0.92
        q = q + 1;
    end
    V = Ve(:,1:q); Vhat = Ve(:,q+1:end);
    C_t = S(1:q,1:q); C_n = V'*C_w*V; % projected q by q
    C_x = fixNegEigs(C_t - C_n);      % projected q by q
    
    C_rp = S(q+1:end,q+1:end); C_np = Vhat'*C_w*Vhat; % projected d-q by d-q
    C_p = fixNegEigs(C_rp - C_np);   % projected d-q by d-q
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate wiener filters for covariance,will use
    % invYcov, sqrtdetYcov, and wienerfilt
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Nz = length(logz);
    for kz = 1:Nz
        z = exp(logz(kz));
        invYcov{kz} = inv(z*C_x + C_n);
        sqrtdetYcov(kz) = sqrt(det(z*C_x + C_n));
        
        invYcov_p{kz} = inv(C_p + C_np);
        sqrtdetYcov_p(kz) = sqrt(det(C_p + C_np));
        % wiener filters for covariance
        wftotal{kz} = z*C_x/(z*C_x + C_n);
        wftotal_p{kz} = C_p/(C_p + C_np);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % main loop - integrate over logz
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Npatches = size(patches,2);
    
    xhat_sum = zeros(q,Npatches); 
    xhat_sum_p = zeros(prod(block)-q,Npatches);
    
    norm = zeros(1,Npatches);
    norm_p = zeros(1,Npatches);
    
    fprintf('Denoising (Nz=%g) ',Nz);
    for kz = 1:Nz
        fprintf(' %g',kz);
        % projet on q by q
        xhat = wftotal{kz}*V'*patches;
        quadform = -(1/2)*sum(V'*patches.*(invYcov{kz}*V'*patches));
        w = (1/Nz)*(1/sqrtdetYcov(kz)).*exp(quadform);% w is proportional to p(y|z)
        w = w(:)';
        xhat_sum = xhat_sum + bsxfun(@times,xhat,w);
        norm = norm + w;
        
        % projet on d-q by d-q
        xhat_p = wftotal_p{kz}*Vhat'*patches;
        quadform_p = -(1/2)*sum(Vhat'*patches.*(invYcov_p{kz}*Vhat'*patches));
        w_p = (1/Nz)*(1/sqrtdetYcov_p(kz)).*exp(quadform_p);% w is proportional to p(y|z)
        w_p = w_p(:)';
        xhat_sum_p = xhat_sum_p + bsxfun(@times,xhat_p,w_p);
        norm_p = norm_p + w_p;
    end
    fprintf('\n');
    
    norm(norm==0) = 1;
    xhat = bsxfun(@rdivide,xhat_sum, norm);
    
    norm_p(norm_p==0) = 1;
    xhat_p = bsxfun(@rdivide,xhat_sum_p, norm_p);

    w1 = V*xhat + Vhat*xhat_p;
    w1 = w1(centerind,:);
    
    wcmp(:,k) = w1';
    logGauss(:,k) = loggausspdf(patches,model.Sigma(:,:,k));
end

logWeightGauss = bsxfun(@plus,logGauss,log(model.weight));
logSum = logsumexp(logWeightGauss,2);
logR = bsxfun(@minus,logWeightGauss,logSum);
R = exp(logR);

dcoef = sum(wcmp.*R,2);
if any(isnan(vec(dcoef)))
    fprintf('NaN is detected!\n');
end

dcoef = reshape(dcoef,size(coef));
% keyboard;

end