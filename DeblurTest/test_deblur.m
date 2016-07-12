clear;

imgName = 'Barbara512.png';
s = double(imread(imgName));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ker=fspecial('average',15);
ker = fspecial('gaussian', 11, 3);
% ker = fspecial('motion', 15, 30);
% ker = fspecial('disk', 7);
% H = fspecial('gaussian',HSIZE,SIGMA)
% ker = 1;   % test for denoising
tol=1e-3;
blur=@(f,k)imfilter(f,k,'circular');    % this is the circular convolution of f with k(-x)
og=blur(s,ker);     % blurred image

Nsig = 10;
rng(0,'v4');
noise = Nsig*randn(size(s));
x = og + noise;         % blurred and noisy image
figure; ShowImage(x);
t = sprintf('Original PSNR = %f', PSNR(s, x));
title(t);


[m, n] = size(x);
[nker,mker]=size(ker);
tmp=zeros(m,n);tmp(1:nker,1:mker)=ker;
tmp=circshift(tmp,[-floor(nker/2),-floor(mker/2)]);
khat = conj(fft2(tmp));

% figure; ShowImage(fftshift(tmp));
% figure; mesh(fftshift(abs(khat)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inverse Filtering:   No noise
% khat_new = khat;
% khat_new(abs(khat_new)<=eps)=eps;
% yf = fft2(x)./khat_new;
% y = real(ifft2(yf));
% 
% figure; ShowImage(y);
% t = sprintf('Restored PSNR = %f', PSNR(y,s));
% title(t);

%% Wiener Filtering
% khat_new = khat;
% khat_new(abs(khat_new)<eps)=eps;
% 
% 
% Snn = Nsig^2;
% Syy = abs(fft2(x)).^2/(m*n);
% % Sxx = max(Syy - Snn, eps);
% % Sxx = Sxx./abs(khat_new).^2;
% Sxx = abs(fft2(s)).^2/(m*n);
% 
% deno = abs(khat_new).^2 + Snn./Sxx;
% deno(abs(deno)<eps) = eps;
% G = conj(khat_new)./deno;
% 
% 
% 
% % Snn = Nsig^2;
% % Syy = abs(fft2(x)).^2/(m*n);
% % Sxx = max(Syy - Snn, eps);
% % G = Sxx./Syy./khat_new;
% 
% yf = G.*fft2(x);
% y = real(ifft2(yf));
% 
% figure; ShowImage(y);
% t = sprintf('Restored PSNR = %f', PSNR(y,s));
% title(t);
% 
% figure;mesh(abs(fftshift(G)))

%% Richardson Lucy

% niter = 10000;
% yk = cell(1, niter+1);
% yk{1} = x;
% for k = 1:niter
%     tmp2 = blur(yk{k},ker);
%     tmp2 = x./tmp2;
%     tmp2 = blur(tmp2, ker(end:(-1):1, end:(-1):1));
%     yk{k+1} = yk{k}.*tmp2;
%     
%     if mod(k,20)==0
%         fprintf('PSNR = %f, iter = %d\n', PSNR(yk{k+1}, s), k);
%     end
% %     figure; ShowImage(yk{k+1});
% %     t = sprintf('Restored PSNR = %f', PSNR(yk{k+1},s));
% %     title(t);
% end
% 
% 
% figure; ShowImage(yk{niter+1});
% t = sprintf('Restored PSNR = %f', PSNR(yk{niter+1},s));
% title(t);


% niter = 100;
% % yk = cell(1, niter+1);
% yk = x;
% for k = 1:niter
%     tmp2 = blur(yk,ker);
%     tmp2 = x./tmp2;
%     tmp2 = blur(tmp2, ker(end:(-1):1, end:(-1):1));
%     yk = yk.*tmp2;
%     
% %     if mod(k,20)==0
%         fprintf('PSNR = %f, iter = %d\n', PSNR(yk, s), k);
% %     end
% %     figure; ShowImage(yk{k+1});
% %     t = sprintf('Restored PSNR = %f', PSNR(yk{k+1},s));
% %     title(t);
% end
% 
% 
% figure; ShowImage(yk);
% t = sprintf('Restored PSNR = %f', PSNR(yk,s));
% title(t);

%% Wavelet Residue Regularization
fb = SplineLinear1d;
WT = FrameletUndec2D(fb);
WT.nlevel = 3;
WT.level_norm = 3;
WT.nor = WT.CalFilterNorm;

niter = 100;
yk = x;
for k = 1:niter
    
    res = x - blur(yk, ker);
    WT.coeff = WT.decomposition(res);
    WT.coeff = WT.normcoeff;
    
    thr_func = @(coeff) coeff.*(abs(coeff)>3*Nsig);
    WT.coeff = WT.operate_band1(thr_func, WT.coeff);
    WT.coeff = WT.unnormcoeff;
    res_new = WT.reconstruction;
    
    tmp2 = blur(yk,ker);
    tmp2 = (tmp2+res_new)./tmp2;
    tmp2 = blur(tmp2, ker(end:(-1):1, end:(-1):1));
    
    yk = yk.*tmp2;
    
    
%     if mod(k,20)==0
        fprintf('PSNR = %f, iter = %d\n', PSNR(yk, s), k);
%     end
    if mod(k,5)==0

    figure; ShowImage(yk);
    t = sprintf('Restored PSNR = %f', PSNR(yk,s));
    title(t);
    end
    
end
    
    figure; ShowImage(yk);
    t = sprintf('Restored PSNR = %f', PSNR(yk,s));
    title(t);


%% Section 2 Title
% Description of second code block
a=2;
