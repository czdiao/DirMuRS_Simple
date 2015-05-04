function [w1] = BLSGSM(coef,noise,params,sig)

% This code implements the Gaussian scale mixture(GSM) denoising by
% decompoing dirac impulse. 
% Adapted from Javier Portilla's code. Mainly for UNDECIMATED tensor
% product complex tight framelets (TP-CTF).
% Inputs: 
%       coef  : coefficients need to be denoised
%       noise : spectrum dirac impulse after transform 
%       params: parameters
%          params.block = [3 3]; % block size
%          params.optim = 1;
%          params.parent = 1;
%          params.covariance = 1;
%       sig : noise standard deviation;
% Outputs:
%      thr_coef: denoised coefficients

block      = params.block;
prnt       = params.parent;
covariance = params.covariance;
optim      = params.optim;

if ~exist('covariance'),
        covariance = 1;
end

if ~exist('optim'),
        optim = 1;
end

[nv,nh,nb] = size(coef);
% Discard the outer coeffs for the reference (centrral) coeffs (to avoid boundary effects)
nblv = nv-block(1)+1;
nblh = nh-block(2)+1;
% number of coefficients considered
nexp = nblv*nblh;
% hidden variable z
zM   = zeros(nv,nh);

w1   = zeros(nv,nh);	% preallocate
N    = prod(block) + prnt; % size of the neighborhood

Ly = (block(1)-1)/2;
Lx = (block(2)-1)/2;
% block(1) and block(2) must be odd!
if (Ly~=floor(Ly))||(Lx~=floor(Lx)),
   error('Spatial dimensions of neighborhood must be odd!');
end   
% reference coeff in the nbhd (central coef in the fine band)
cent = floor((prod(block)+1)/2);

Y = zeros(nexp,N);% It will be the observed signal (rearranged in nexp neighborhoods)
W = zeros(nexp,N);% It will be a signal with the same autocorrelation as the noise

foo = zeros(nexp,N);

% Compute covariance of noise from 'noise'
n = 0;
for ny = -Ly:Ly,	% spatial neighbors
	for nx = -Lx:Lx,
		n = n + 1;
		foo = shift(noise(:,:,1),[ny nx]);
		foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
		W(:,n) = foo(:);
	end
end
if prnt,	% parent
	n = n + 1;
	foo = noise(:,:,2);
	foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
	W(:,n) = foo(:);
end

C_w = (W'*W)/nexp;
sig2 = mean(diag(C_w(1:N-prnt,1:N-prnt)));	% noise variance in the (fine) subband

clear W;
if ~covariance,
   if prnt,
        C_w = diag([sig2*ones(N-prnt,1);C_w(N,N)]);
   else
        C_w = diag(sig2*ones(N,1));
   end
end    


% Rearrange observed samples in 'nexp' neighborhoods 
n = 0;
for ny=-Ly:Ly,	% spatial neighbors
	for nx=-Lx:Lx,
		n = n + 1;
		foo = shift(coef(:,:,1),[ny nx]);
		foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
		Y(:,n) = foo(:);
	end
end
if prnt,	% parent
	n = n + 1;
	foo = coef(:,:,2);
	foo = foo(Ly+1:Ly+nblv,Lx+1:Lx+nblh);
	Y(:,n) = foo(:);
end
clear foo

[S,dd] = eig(C_w);
S = S*real(sqrt(dd));	% S*S' = C_w
iS = pinv(S);
clear noise

% observed (signal + noise) variance in the subband
C_y = (Y'*Y)/nexp;
sy2 = mean(diag(C_y(1:N-prnt,1:N-prnt)));

C_x = C_y - C_w;
[Q,L] = eig(C_x);
% correct possible negative eigenvalues, without changing the overall variance
L = diag(diag(L).*(diag(L)>0))*sum(diag(L))/(sum(diag(L).*(diag(L)>0))...
    +(sum(diag(L).*(diag(L)>0))==0));
C_x = Q*L*Q';
   
sx2 = sy2 - sig2;   % estimated signal variance in the subband
sx2 = sx2.*(sx2>0); % + (sx2<=0); 
if ~covariance,
   if prnt,
        C_x = diag([sx2*ones(N-prnt,1);C_x(N,N)]);
   else
        C_x = diag(sx2*ones(N,1));
   end
end    
[Q,L] = eig(iS*C_x*iS'); % Double diagonalization of signal and noise
la = diag(L);			% eigenvalues: energy in the new represetnation.
la = real(la).*(real(la)>0);

% Linearly transform the observations
V = Q'*iS*Y';
clear Y;
V2 = (V.^2).';
M = S*Q;
m = M(cent,:);

% Compute p(Y|log(z))
if 1,   % non-informative prior
    lzmin = -20.5; lzmax = 3.5; step = 2;
else    % gamma prior for 1/z
    lzmin = -6; lzmax = 4; step = 0.5;
end    

lzi = lzmin:step:lzmax; % log(z)
nsamp_z = length(lzi);
zi = exp(lzi);
laz = la*zi;
% p_lz = zeros(nexp,nsamp_z);
% mu_x = zeros(nexp,nsamp_z);

% Compute P(Y|z), Gaussian actually
pg1_lz = 1./sqrt(prod(1 + laz,1));
aux = exp(-0.5*V2*(1./(1+laz)));
p_lz = aux*diag(pg1_lz);

% Compute mu_x(z) = E{x|log(z),Y}
aux = diag(m)*(laz./(1 + laz));	% Remember: laz = la*zi
mu_x = V.'*aux;	% Wiener estimation, for each considered sample of z

                                           
[~, ind] = max(p_lz.');	% We use ML estimation of z only for the boundaries.
if numel(ind) == 0,
	z = ones(1,size(ind,2));
else
	z = zi(ind).';				
end
clear V2 aux

% For boundary handling
uv=1+Ly; lh=1+Lx;
dv=nblv+Ly; rh=nblh+Lx;
ul1=ones(uv,lh);
u1=ones(uv-1,1);
l1=ones(1,lh-1);
ur1=ul1; dl1=ul1; dr1=ul1;
d1=u1; r1=l1;
zM(uv:dv,lh:rh) = reshape(z,nblv,nblh);

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
w1 = coef(:,:,1).*(sx2*zM)./(sx2*zM + sig2);

% Prior for log(z)
p_z = ones(nsamp_z,1);    % Flat log-prior (non-informative for GSM)
p_z = p_z/sum(p_z);

% Compute p(log(z)|Y) from p(Y|log(z)) and p(log(z)) (Bayes Rule)
p_lz_y = p_lz*diag(p_z);
clear p_lz
if ~optim,
    % ML in log(z): it becomes a delta function
    p_lz_y = (p_lz_y==max(p_lz_y')'*ones(1,size(p_lz_y,2)));
end    
aux = sum(p_lz_y, 2);
if any(aux==0),
    foo = aux==0;
    p_lz_y = repmat(~foo,1,nsamp_z).*p_lz_y./repmat(aux + foo,1,nsamp_z)...
        + repmat(foo,1,nsamp_z).*repmat(p_z',nexp,1);% Normalizing: p(log(z)|Y)
else
    p_lz_y = p_lz_y./repmat(aux,1,nsamp_z); 	% Normalizing: p(log(z)|Y)
end    
clear aux;

% Compute E{x|Y} = int_log(z){ E{x|log(z),Y} p(log(z)|Y) d(log(z)) }
aux = sum(mu_x.*p_lz_y, 2);
w1(1+Ly:nblv+Ly,1+Lx:nblh+Lx) = reshape(aux,nblv,nblh);

clear mu_x p_lz_y aux


end