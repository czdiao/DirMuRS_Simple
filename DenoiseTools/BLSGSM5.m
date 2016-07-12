function [w1] = BLSGSM5(coef,C_w,logz,params)
%
% This code implements the Gaussian scale mixture (GSM) for DECIMATED Tensor 
% product complex tight framelets (TP-CTF) with precalculated noise 
% covariance matrix (C_w) in EACH band.
%
% Inputs: 
%       coef: either real or imaginary part of noisy coef in ONE band
%       C_w : either real or imaginary part of noise cov matrix in ONE
%               band
%       logz: 13 samples of multiplier z in log
%       params: denoising params
%              params.block = [3 3]; % block size
%              params.optim = 1;
%              params.parent = 0; % use parent or not (1/0)
%              params.covariance = 1;
% Outputs:
%       w1 :  denoised coefficients in ONE band
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
C_y = norpatch*norpatch'/size(norpatch,2);
C_x = fixNegEigs(C_y - C_w);


centerind = floor((prod(block)+1)/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate wiener filters for covariance,will use 
% invYcov, sqrtdetYcov, and wienerfilt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nz = length(logz);
invYcov = cell(1, Nz);
sqrtdetYcov = zeros(1, Nz);
wienerfilt = cell(1, Nz);

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
% patches = packVecPatches(coef,block);
patches = allp;
Npatches = size(patches,2);
xhat_sum_p = zeros(1,Npatches);
norm = zeros(1,Npatches);

% fprintf('Denoising (Nz=%g) ',Nz);
for kz = 1:Nz
%     fprintf(' %g',kz);
    wienerfilt_tmp = wienerfilt{kz};
    xhat_p = wienerfilt_tmp*patches;
    invYcov_tmp = invYcov{kz};
%     quadform_p = -(1/2)*sum(patches.*(invYcov_tmp*patches));
    tmp = invYcov_tmp*patches;
    tmp = patches.*tmp;
    quadform_p = -sum(tmp)/2;
    
   
    % w is proportional to p(y|z)
    w = (1/Nz)*(1/sqrtdetYcov(kz)).*exp(quadform_p);
    w = w(:)';
    xhat_sum_p = xhat_sum_p + w.*xhat_p;
    norm = norm + w;
end
% fprintf('\n');

norm(find(norm==0)) = 1;
xhat = xhat_sum_p./norm;

w1 = reshape(xhat',size(coef));

if any(isnan(vec(w1)))
    fprintf('NaN is detected!\n');
end

end