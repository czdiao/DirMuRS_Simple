function  y  = deblur_freq_decomp( x, ker, WT, Nsig, s  )
%DEBLUR_FREQ_DECOMP 
%
%
%
%
%   Chenzhe
%   Jun, 2016
%
%



[m, n] = size(x);
[nker,mker]=size(ker);
tmp=zeros(m,n);
tmp(1:nker,1:mker)=ker;
tmp=circshift(tmp,[-floor(nker/2),-floor(mker/2)]);
fker = fft2(tmp);

% Method 1
tol = 1e-15;
TF = (abs(fker)>tol);
fker = fker.*TF + tol*(~TF);
fkerinverse = 1./fker;

% fkerinverse(abs(fkerinverse)>1e5)=0;

eta = SplineLinear1d;
eta = eta(1);
tmp = double(abs(fkerinverse)<=50);
tmp = eta.tconv(tmp,1);
tmp = eta.tconv(tmp,2);
fkerinverse = fkerinverse.*tmp;



% Method 2, Wiener Filtering
% beta = 3;
% f = 0:1/m:(m-1)/m;
% f = f*2*pi;
% f = f - 2*pi*(f>pi+eps);    % shift into [-pi, pi]
% [X, Y] = meshgrid(f);
% [~, Rho] = cart2pol(X, Y);  % into polar coordinate, Theta \in [-pi, pi]
% xspectrualinverse = Rho.^beta;
% NSR = Nsig * xspectrualinverse;
% fkerinverse = conj(fker)./(abs(fker).^2 + NSR);



fx = fft2(x);
fy = fx.*fkerinverse;

% fy(abs(fker)<0.2) = 0;
yhat = ifft2(fy);   % deconvoluted image, with noise blowup at the high frequency

% tmp1 = fft2(s);
% tmp1(abs(fker)<0.2)=0;
% ttmp = ifft2(tmp1);
% PSNR(s, real(ttmp))

% normboverker = tmpcalFilterNorm(WT, fkerinverse);    % norm of b/ker
%%%%%%%%%%%%%%%%%%%%%%%%%%% % denoise old
% WT.coeff = WT.decomposition(yhat);
% WT.nor = normboverker;   % amplification factor of the noise in each band
% WT.coeff = WT.normcoeff;
% Sig_est = WT.latentSigma(Nsig, 'local_soft');
% 
% % add factor
% bnor = WT.CalFilterNorm;
% fun = @(Gnor, bnor) (1+0.007*Nsig*Gnor./bnor);
% factor = WT.operate_band2(fun, WT.nor, bnor );
% fun2 = @(Sig_est, factor) (Sig_est./factor);
% Sig_est = WT.operate_band2(fun2, Sig_est, factor);
% 
% WT.coeff = WT.LocalSoft(Sig_est,Nsig);
% WT.coeff = WT.unnormcoeff;
% y = WT.reconstruction;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%% denoise by modified local soft
% WT.coeff = WT.decomposition(yhat);
% WT.nor = normboverker;
% Sig_est = WT.latentSigma_unnormalize(Nsig, 'local_soft');
% 
% normb = WT.CalFilterNorm;
% factor = ComputeFactor(normb, normboverker, Nsig);
% WT.coeff = WT.LocalSoft_modified(Sig_est, Nsig, factor);
% % WT.coeff = WT.LocalSoft_unnormalize(Sig_est, Nsig);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% nor = WT.CalFilterNorm_blur([512, 512], fkerinverse);

% GSM denoise step
WT.coeff = WT.decomposition(yhat);
% load CwGaussianKer.mat
[Cwr, Cwi] = WT.CalCovMatrix(512, 5, fkerinverse);

WT.coeff = WT.GSMDenoise(5, Cwr, Cwi, Nsig );

% use local soft
% WT.coeff = WT.decomposition(yhat);
% WT.nor = nor;
% WT.coeff = WT.normcoeff;
% Sig_est = WT.latentSigma(Nsig, 'local_soft');
% WT.coeff = WT.LocalSoft(Sig_est,Nsig);
% WT.coeff = WT.unnormcoeff;


% for j = 1:WT.nlevel
%     nb = length(WT.coeff{1});
%     for ib = 1:nb
%         if nor{j}{ib}*Nsig>500
%             WT.coeff{j}{ib} = WT.coeff{j}{ib}*0;
%         end
%     end
% end

% for j = 1
%     nb = length(WT.coeff{1});
%     for ib = 1:nb
%             WT.coeff{j}{ib} = WT.coeff{j}{ib}*0;
%     end
% end


y = WT.reconstruction;


y = real(y);
y = y.*(y>=0);
y(y>255) = 255;

PSNR_val = PSNR(s,y);
figure;
subplot_tight(1,2,1); ShowImage(x);
subplot_tight(1,2,2); ShowImage(y);
t = num2str(PSNR_val);
title(['PSNR = ' t] );
linkaxes;
fprintf('PSNR = %f\n', PSNR_val);




a = 0;



end

function plotcoeff(coeff)
len = length(coeff);
for i = 1:len
    figure;ShowImage(abs(coeff{i}))
end

end

function nor = tmpcalFilterNorm(obj, fkerinverse)

N = size(fkerinverse, 1);
x = zeros(N);

nL = obj.level_norm;

nor = cell(1,nL);
no = 1;

for scale = 1:nL
    
    obj.nlevel = scale;
    W_zero = obj.decomposition(x);
    num_hipass = length(W_zero{scale});
    nor{scale} = cell(1, num_hipass);
    
    for hipass = 1:num_hipass
        W = W_zero;
        W{scale}{hipass}(no,no) = 1;
        obj.coeff = W;
        y = obj.reconstruction;
        tmp = fft2(y).*fkerinverse;
        nor{scale}{hipass} = norm(abs(tmp), 'fro')/N;  % noise level in each band
%         nor{scale}{hipass} = sqrt(sum(sum(abs(y).^2)));
    end
end



end

function factor = ComputeFactor(normb, normboverker, Nsig)
factor = normb;
nL = length(normb);

for j = 1:nL
    nB = length(factor{j});
    for iB = 1:nB
        tmp = Nsig * (normboverker{j}{iB}./normb{j}{iB});
        factor{j}{iB} = 1 + 9/128 * sqrt(tmp);
    end
end




end



