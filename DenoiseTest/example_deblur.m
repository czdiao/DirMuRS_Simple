%% Show and compare different deblur algorithms
% Compare some known deblur algorithms

clear;
% imgName     ='goldhill256.png';
imgName = 'Barbara512.png';
s = double(imread(imgName));


% ker=fspecial('average',9);
% ker = fspecial('gaussian', 9, 2);
ker = fspecial('motion', 15, 30);
% ker = 1;   % test for denoising
blur=@(f,k)imfilter(f,k,'circular');    % this is the circular convolution of f with k(-x), the zero position of f 
og=blur(s,ker);     % blurred image

Nsig = 20;
rng(0,'v4');
noise = Nsig*randn(size(s));
x = og + noise;         % blurred and noisy image
fprintf('\nOriginal PSNR = %f\n', PSNR(s, x));

% figure; ShowImage(s)


%% Transform

fb = SplineLinear1d;
WT = FrameletUndec2D(fb);
WT.nlevel = 5;


%% Lucy Richardson
%

% for iter = 1:20
%     if mod(iter, 20)==0
%         yLR = deconvlucy(x, ker, iter);
%         figure; ShowImage(yLR);
%         t = sprintf('\nLucy Richardson PSNR = %f\n', PSNR(s, yLR));
%         title(t);
%     end
% end


%% Wiener Filtering

% estimated_nsr = Nsig^2 / var(s(:));
% yW = deconvwnr(x, ker, estimated_nsr);

WTx = WT;   % noisy
WTx.coeff = WTx.decomposition(x);

WTs = WT;   % original
WTs.coeff = WTs.decomposition(s);

WTn = WT;   % pure noise
WTn.coeff = WTn.decomposition(noise);

WTy = WTx;  % denoised

[m, n] = size(x);
[nker,mker]=size(ker);
tmp=zeros(m,n);tmp(1:nker,1:mker)=ker;
tmp=circshift(tmp,[-floor(nker/2),-floor(mker/2)]);
K_hat = fft2(tmp);
K_conj = conj(K_hat);

for j = 1:WT.nlevel
    for iB = 1:length(WTx.coeff{j})
        fx = fft2(WTx.coeff{j}{iB});
        fn = fft2(WTn.coeff{j}{iB});
        fs = fft2(WTs.coeff{j}{iB});
        
        SNR = max(eps, abs(fs./fn).^2);
        wienerfilter = K_conj./(abs(K_hat.^2) + 1./SNR );
        
        fy = fx.*wienerfilter;
        ty = ifft2(fy);
        WTy.coeff{j}{iB} = real(ty);
%         max(imag(ty(:)))
    end
end

yW = WTy.reconstruction;
yW(yW<0)=0;
figure; ShowImage(yW);
t = sprintf('\nWiener Filtering PSNR = %f\n', PSNR(s, yW));
title(t);

figure; ShowImage(x)
t = sprintf('\nOriginal PSNR = %f\n', PSNR(s, x));
title(t);


res = blur(yW, ker)-x;
WTres = WT;
WTres.coeff = WTres.decomposition(res);











