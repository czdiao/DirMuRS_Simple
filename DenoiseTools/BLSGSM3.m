function [w1] = BLSGSM3(coef,C_w,logz,params)

% This code implements the decimated GSM with p(z) lognormal,with 
% precalculatd noise covariance, not usually being used. 
% The performance is not as good as general GSM and is SLOW!! Not usually
% being used.
%
% Input:
%      coef   :   the noisy coef band
%      C_w    :   the noise cov matrix
%      logz   :   logz list (may not be used)
%      params :   denoising params
%               params.block = [3 3]: size of nbhd
%               params.parent = 1/0 : use parent or not
% Output:
%      w1  :  the denoised coef band
%
% Tol_z is the stopping criteria for bisection estimation of z_hat
% default Tol_z = 10^(-4)

%%
block = params.block;
prnt  = params.parent;
[nv,nh,nb] = size(coef); 

%% Compute the coeff covariance C_x
% Discard the outer coeffs for the reference 
% (central) coeffs to avoid boundary effects)
interior_mask = makeInteriorMask([nv nh],floor(max(block)/2));
allp = packVecPatches(coef,block);
norpatch = allp(:,interior_mask(:));
C_y = norpatch*norpatch'/size(norpatch,2);
C_x = fixNegEigs(C_y - C_w);
centerind = floor((prod(block)+1)/2);

%% Estimation of the log(z) parameters
sig2_z = (mean2(norpatch.^4)/3-std2(norpatch)^4)/(std2(norpatch)^2-C_w(1,1))^2; 
if sig2_z<=0,
    sig2_z = eps;
%     sig2_z = abs(sig2_z);
    disp('Warning!!:sig2_z is not positive, eps is used!\n'); 
end
mu_l   = -log(sig2_z+1)/2;
sig2_l = log(sig2_z+1);

% Computing S = C_w^(1/2)
[Vw,dd] = eig(C_w);
S = Vw*real(sqrt(dd))*Vw'; % S*S' = C_w
iS = pinv(S);
if ~isreal(iS), 
    error('iS is not real'); 
end

[Q,L] = eig(iS*C_x*iS');% Double diagonalization of signal and noise
lamb = diag(L);	        % eigenvalues: energy in the new represetnation.
lamb = real(lamb).*(real(lamb)>0); 
lamb(lamb==0) = eps;

% Linear transformation of the observations, and keep the quadratic values 
patches = packVecPatches(coef,block);
V = real(Q)'*iS*patches;
zn = (V.^2-1)./repmat(lamb,1,length(V));
lamb_vec_i = repmat(lamb.^-1,1,size(zn,2));

%% Estimation of z
% Initialization of the bisection method
b_ub = 50; pos_m = 1;
a = zeros(1,length(zn)) + eps;
a_vec = repmat(a,size(zn,1),1);
f_cost_a = (log(a)-mu_l+sig2_l)./(a*sig2_l) + sum((a_vec-zn)./(a_vec+lamb_vec_i).^2);
while pos_m~=0
    b = b_ub*ones(1,length(zn));
    b_vec = repmat(b,size(zn,1),1);
    f_cost_b = (log(b)-mu_l+sig2_l)./(b*sig2_l) + sum((b_vec-zn)./(b_vec+lamb_vec_i).^2);
    pos_m = sum((f_cost_a<0)-(f_cost_b>0));
    b_ub = b_ub + 50;
    if b_ub == 10000, 
        error('Upper and lower bound of the bisection method do not return different signs'); 
    end 
end

% Bisection method
Tol_z = 10^-4;
while max(abs(b-a)) > Tol_z
    z_hat = (a+b)/2;
    z_vec = repmat(z_hat,size(zn,1),1); %vectorized Z
    f_cost = (log(z_hat)-mu_l+sig2_l)./(z_hat*sig2_l) + sum((z_vec-zn)./(z_vec+lamb_vec_i).^2);    
    a(f_cost<0) = z_hat(f_cost<0);
    b(f_cost>0) = z_hat(f_cost>0);
end
z_hat = (a+b)/2; 
z_hat = z_hat./mean(z_hat); % regularization of the estimated multiplier
M = S*Q;

%% Calculate final estimate: x_hat = sum(m_cn*v_n/1+z_hat^(-1)*lamb_n^(-1))
x_hat = sum(repmat(M(centerind,:)',1,size(zn,2)).*(V./(1+repmat(z_hat.^-1,size(zn,1),1).*lamb_vec_i)));
% w1(1+Ly:nblv+Ly,1+Lx:nblh+Lx) = col2im(x_hat,block,size(coef));
w1 = reshape(x_hat',size(coef));
% tmp = col2im(x_hat,block,size(coef));
% w1 = symext(tmp,1);

end