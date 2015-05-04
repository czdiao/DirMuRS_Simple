function [w1] = BLSGSM6(coef,C_w,logz,params)
%
% This code TESTS the Mixtures of projected Gaussian Scale Mixture (MPGSM)
% for DECIMATED Tensor product complex tight framelets (TP-CTF) with 
% precalculated noise covariance matrix (C_w) in EACH band.
% 
% NO EM PROCEDURE IS INVOLVED. This code is not often called, test only.
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
%       w1: denoised coefficients in ONE band
% 
%% 
block = params.block;
prnt  = params.parent;
[nv,nh,nb] = size(coef); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the coeff covariance C_x
% Discard the outer coeffs for the reference 
% (central) coeffs to avoid boundary effects)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interior_mask = makeInteriorMask([nv nh],floor(max(block)/2));
allp = packVecPatches(coef,block);
norpatch = allp(:,interior_mask(:));
centerind = floor((prod(block)+1)/2);
C_y = norpatch*norpatch'/size(norpatch,2);
% Use PCA to calculate the project bases
[~,S,Ve] = svd(C_y); % NOTE: C_y = Ve*S*Ve';
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
patches = packVecPatches(coef,block);
Npatches = size(patches,2);

xhat_sum = zeros(q,Npatches); xhat_sum_p = zeros(prod(block)-q,Npatches);
norm = zeros(1,Npatches);  norm_p = zeros(1,Npatches);

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

norm(norm==0) = 1; norm_p(norm_p==0) = 1;
xhat = bsxfun(@rdivide,xhat_sum, norm);
xhat_p = bsxfun(@rdivide,xhat_sum_p, norm_p);

w1 = V*xhat + Vhat*xhat_p;
w1 = w1(centerind,:);
w1 = reshape(w1',size(coef));

if any(isnan(vec(w1)))
    fprintf('NaN is detected!\n');
end
end