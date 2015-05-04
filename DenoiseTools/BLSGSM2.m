function [w1] = BLSGSM2(coef,noise,params,sig)

% This code implements the undecimated GSM with p(z) lognormal density, with 
% decomposing dirac to calculate noise covariance,  not usually being used.
% The performance is not as good as general GSM and is SLOW!! Not usually
% being used.
% Input:
%       coef:   the noisy coef band 
%       noise:  the noise used to calculate C_w
%       params: the parameters
%               params.block = [3 3]: size of nbhd.
%                   Note: [5 5] yields better results than that of [3 3]
%               params.parent = 1/0 : use parent or not
% Output:
%       w1: the denoised coef band
%
% Tol_z is the stopping criteria for bisection estimation of z_hat
% default Tol_z = 10^(-4)
%%
block = params.block;
prnt  = params.parent;

[nv,nh,nb] = size(coef);
% Discard the outer coeffs for the reference (centrral) coeffs (to avoid boundary effects)
nblv = nv-block(1)+1;
nblh = nh-block(2)+1;
nexp = nblv*nblh;  % number of coefficients considered
zM = zeros(nv,nh); % hidden variable z
N  = prod(block) + prnt; % size of the neighborhood
Ly = (block(1)-1)/2;
Lx = (block(2)-1)/2;
% block(1) and block(2) must be odd!
if (Ly~=floor(Ly))||(Lx~=floor(Lx)),
   error('Spatial dimensions of neighborhood must be odd!');
end   
cent = floor((prod(block)+1)/2);
y = zeros(N,nexp);
nois_y = zeros(N,nexp);

% Compute covariance of noise C_w from 'noise'
n = 0;
for ny = -Ly:Ly,	% spatial neighbors
	for nx = -Lx:Lx,
		n = n + 1;
		foo = shift(noise(:,:,1),[ny nx]);
		foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
		nois_y(n,:) = foo(:)';
	end
end
if prnt,	% parent
	n = n + 1;
	foo = noise(:,:,2);
	foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
	nois_y(n,:) = foo(:)';
end

C_w = (nois_y*nois_y')/nexp;
sig2 = mean(diag(C_w(1:N-prnt,1:N-prnt)));

% Rearrange observed samples in 'nexp' neighborhoods 
n = 0;
for ny=-Ly:Ly,	% spatial neighbors
	for nx=-Lx:Lx,
		n = n + 1;
		foo = shift(coef(:,:,1),[ny nx]);
		foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
		y(n,:) = foo(:)';
	end
end
if prnt,	% parent
	n = n + 1;
	foo = coef(:,:,2);
	foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
	y(n,:) = foo(:)';
end
clear foo
% observed (signal + noise) variance in the subband
C_y = (y*y')/nexp;
sy2 = mean(diag(C_y(1:N-prnt,1:N-prnt)));

if mean(diag(C_w))>=mean(diag(C_y))
    disp('Warning!!: Signal is not detectable at this noise level');
%     error(['The Maximum recommended standard deviation of the noise is:',...
%       num2str(0.9*mean(diag(C_y)))]);
end

%% Estimation of the log(z) parameters
sig2_z = (mean2(y.^4)/3-std2(y)^4)/(std2(y)^2-std2(nois_y)^2)^2; 
if sig2_z<=0,
%     sig2_z = eps;
    sig2_z = abs(sig2_z);
    disp('Warning!!:sig2_z is not positive, abs is used!'); 
end
mu_l   = -log(sig2_z+1)/2;
sig2_l = log(sig2_z+1);
%%
% Computing C_u
C_u = fixNegEigs(C_y - C_w);
% [Q,L] = eig(C_u);
% L = diag(diag(L).*(diag(L)>0))*sum(diag(L))/(sum(diag(L).*(diag(L)>0))+...
%     (sum(diag(L).*(diag(L)>0))==0));
% C_u = Q*L/Q;

su2 = sy2 - sig2;   % estimated signal variance in the subband
su2 = su2.*(su2>0);


% Computing S=C_w^(1/2)
[Vw,dd] = eig(C_w);
S = Vw*real(sqrt(dd))*Vw'; % S*S' = C_w
iS = pinv(S);
if ~isreal(iS), 
    error('iS is not real'); 
end

[Q,L] = eig(iS*C_u*iS');% Double diagonalization of signal and noise
lamb = diag(L);	        % eigenvalues: energy in the new represetnation.
lamb = real(lamb).*(real(lamb)>0); 
lamb(lamb==0) = eps;

% Linear transformation of the observations, and keep the quadratic values 
V = real(Q)'*iS*y;    
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

%% for boundary handling
uv=1+Ly; lh=1+Lx;
dv=nblv+Ly; rh=nblh+Lx;
ul1=ones(uv,lh);
u1=ones(uv-1,1);
l1=ones(1,lh-1);
ur1=ul1; dl1=ul1; dr1=ul1;
d1=u1; r1=l1;
zM(uv:dv,lh:rh) = reshape(z_hat,nblv,nblh);
% Propagation of the ML-estimated z to the boundaries
% a) Corners
zM(1:uv,1:lh)=zM(uv,lh)*ul1;
zM(1:uv,rh:nh)=zM(uv,rh)*ur1;
zM(dv:nv,1:lh)=zM(dv,lh)*dl1;
zM(dv:nv,rh:nh)=zM(dv,rh)*dr1;
% b) Bands
zM(1:uv-1,lh+1:rh-1)=u1*zM(uv,lh+1:rh-1);
zM(dv+1:nv,lh+1:rh-1)=d1*zM(dv,lh+1:rh-1);
zM(uv+1:dv-1,1:lh-1)=zM(uv+1:dv-1,lh)*l1;
zM(uv+1:dv-1,rh+1:nh)=zM(uv+1:dv-1,rh)*r1;
% We do scalar Wiener for the boundary coefficients
w1 = coef(:,:,1).*(su2*zM)./(su2*zM + sig2);

%% Calculate final estimate: x_hat = sum(m_cn*v_n/1+z_hat^(-1)*lamb_n^(-1))
x_hat = sum(repmat(M(cent,:)',1,size(zn,2)).*(V./(1+repmat(z_hat.^-1,size(zn,1),1).*lamb_vec_i)));
w1(1+Ly:nblv+Ly,1+Lx:nblh+Lx) = col2im(x_hat,block,size(coef));
% tmp = col2im(x_hat,block,size(coef));
% w1 = symext(tmp,1);

end