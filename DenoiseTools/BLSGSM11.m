function [w1] = BLSGSM11(coef,C_w,logz,params, SigmaY)
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
%
%
%   Changed from GLSGSM10. The covariance matrix C_y is now computed
%   locally, however diagonal: sigma_y^2 * I.
%
%
%   Chenzhe
%   July, 2016
%
%
%%
block = params.block;

[nv,nh] = size(coef); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute the coeff covariance C_x
% Discard the outer coeffs for the reference 
% (central) coeffs to avoid boundary effects)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allp = packVecPatches(coef,block);
Npatches = size(allp,2);

[P, lambda_w] = eig(C_w);
lambda_w = diag(lambda_w);  % col
lambda_y = SigmaY(:)';      % row
lambda_x = bsxfun(@minus, lambda_y.^2, lambda_w);

% correct possible negative eigenvalues, without changing the overall variance
total_var_orig = sum(lambda_x, 1);
lambda_x = lambda_x.*(lambda_x>0);
total_var = sum(lambda_x, 1);
total_var(total_var==0) = 1;
r = total_var_orig./total_var;
lambda_x = bsxfun(@times,lambda_x, r);


centerind = floor((prod(block)+1)/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate wiener filters for covariance,will use 
% invYcov, sqrtdetYcov, and wienerfilt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nz = length(logz);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% main loop - integrate over logz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xhat_sum_p = zeros(1,Npatches);
norm = zeros(1,Npatches);

% prepare Chenzhe
% [S,dd] = eig(C_w);
% S = S*real(sqrt(dd));	% S*S' = C_w
% iS = pinv(S);
% 
% [Q,L] = eig(iS*C_x*iS');	 	% Double diagonalization of signal and noise
% la = diag(L);						% eigenvalues: energy in the new represetnation.
% la = real(la).*(real(la)>0);    
% la = la';                       % lambda, row vector

V = P'*allp;
V2 = V.^2;
m = P(centerind,:).*la;
detw = det(C_w);

% fprintf('Denoising (Nz=%g) ',Nz);
for kz = 1:Nz
%     fprintf(' %g',kz);
    
    z = exp(logz(kz));
    xhat_p = z * m./(z*la+1) * V;
    
    quadform_p = -0.5./(z*la+1) * V2;   % row vector
    sqrtdetYcov = sqrt(detw * prod(z*la+1));
    
   
    % w is proportional to p(y|z)
    w = (1/Nz)*exp(quadform_p)/sqrtdetYcov;
    xhat_sum_p = xhat_sum_p + w.*xhat_p;
    norm = norm + w;
end
% fprintf('\n');

norm(norm==0) = 1;
xhat = xhat_sum_p./norm;

w1 = reshape(xhat',size(coef));

if any(isnan(vec(w1)))
    fprintf('NaN is detected!\n');
end

end