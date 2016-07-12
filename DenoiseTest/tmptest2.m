%% Set Home Path and Add to Path
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% OLD_CODE = [HOME_PATH 'old_code'];
% path(pathdef);
% addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));

%%
% clear;
% 
% % imgName    = '1.1.03.tiff';
% % imgName    = 'Pressed calf leather.tiff';
% % imgName    = 'Mandrill.png';
% imgName = 'Barbara512.png';
% s = double(imread(imgName));
% 
% ss = s(321:321+31,471:471+31);
% % s = repmat(ss,16);
% % s = ss;
% 
% 
% % Nsig = 40;
% % rng(0,'v4');
% % n = Nsig*randn(size(s));
% % x = s + n;
%% Test for DCT2
% sdct = dct2(s);
% 
% sdct(abs(sdct)<10)=0;
% 
% tmp = idct2(sdct);
% 
% figure;ShowImage(tmp)
% 
% PSNR(tmp, s)
% figure;ShowImage(abs(s-tmp))


%% Test for DCT2

% x = x-128;

% wdct = dct2(x);
% 
% for alpha = 2.6:0.1:4.0
% w = hard(wdct, alpha*Nsig);
% y = idct2(w);
% y = y+128;
% 
% r = PSNR(y, s);
% fprintf('%f, %f\n', alpha, r);
% end



% figure; 
% subplot(1,3,1);ShowImage(x);

% subplot(1,3,2);ShowImage(y)
% t = num2str(r);
% title([t '    dct2block']);

% err = abs(y-s);
% subplot(1,3,3);ShowImage(err)


%% Test for Repeating texture in Freq domain

% s = s-128;
% figure; ShowImage(s)
% 
% fs = fftshift(abs(fft2(s)));
% fs = log(fs);
% 
% figure; ShowImageColor(fs)
% 
% 
% % x = zeros(512);
% % x(1:32, 1:32) = s;
% % figure; ShowImage(x);
% % fx = fftshift(abs(fft2(x)));
% % fx = log(fx);
% % figure; ShowImageColor(fx)
% % 
% % y = repmat(s,16);
% % figure; ShowImage(y);
% % fy = fftshift(abs(fft2(y)));
% % fy = log(fy);
% % figure; ShowImageColor(fy);
% 
% 
% mask = zeros(32);
% mask(9:(32-8), 9:(32-8)) = 1;
% mask = GenSmoothMask(mask, 8);
% % figure; ShowImageColor(mask);
% 
% snew = s.*mask;
% figure; ShowImage(snew);
% 
% fsnew = fftshift(abs(fft2(snew)));
% fsnew = log(fsnew);
% figure; ShowImageColor(fsnew)
% 
% 
% x = zeros(512);
% x(1:32, 1:32) = snew;
% figure; ShowImage(x);
% fx = fftshift(abs(fft2(x)));
% fx = log(fx);
% figure; ShowImageColor(fx)


%%
% % Original
% s = s-128;
% % figure; ShowImage(s);
% fs_orig = fft2(s);
% fs = fftshift(abs(fs_orig));
% fs = log(fs);
% figure; ShowImageColor((fs))
% % figure; ShowImageColor(ifftshift(fs));

%% mask, special area test

% mask = zeros(size(fs_orig)/2);
% mask(7:61, 120:155) = 1;
% mask = [mask, zeros(size(mask))];
% mask = GenSmoothMaskHalfFreq(mask, 8);
% 
% figure; ShowCutBdry(fs, fftshift(mask), true);
% 
% fs_new = mask.*fs_orig;
% y = ifft2(fs_new);
% y = real(y);
% figure; ShowImage(y)

%% mask, axis test
% mask11 = zeros(size(fs_orig)/2);
% L = 4;
% mask11(1:L,:) = 1;
% mask11(:, 1:L) = 1;
% mask1 = GenSmoothMaskQuarterFreq(mask11, 8);
% 
% mask21 = zeros(size(fs_orig)/2);
% L = 32;
% mask21(1:L, 1:L)= 1;
% mask2 = GenSmoothMaskQuarterFreq(mask21, 8);
% 
% mask01 = mask11 & (~mask21);
% mask = GenSmoothMaskQuarterFreq(mask01, 8);
% 
% figure; ShowCutBdry(fs, fftshift(mask), true);
% 
% fs_new = fs_orig.*mask;
% y = ifft2(fs_new);
% y = real(y);
% figure; ShowImage(y)




%% Test for GenSmoothMask

% x = zeros(512);
% 
% x(65:447, 65:447) = 1;
% % x (50:128, 50:128) = 1;
% figure; ShowImage(x);
% 
% mask = GenSmoothMask(x, 32);
% figure; ShowImage(mask)

%% Test for deblur
clear;

imgName    = 'goldhill256.png';
% imgName     ='Barbara512.png';

s = double(imread(imgName));

fb = SplineLinear1d;
nL = 4;     % decomposition levels
dtwavelet = FrameletUndec2D(fb);
dtwavelet.level_norm = nL;
dtwavelet.nlevel = nL;
% dtwavelet.nor = dtwavelet.CalFilterNorm;

sigmaN = [5, 10, 25, 40, 50, 80, 100];  % noise level
len = length(sigmaN);

ker=fspecial('average',9);
% ker = fspecial('gaussian', 9, 2);
% ker = 1;   % test for denoising
tol=1e-3;
blur=@(f,k)imfilter(f,k,'circular');    % this is the circular convolution of f with k(-x), the zero position of f 
og=blur(s,ker);     % blurred image

Nsig = 3;
rng(0,'v4');
n = Nsig*randn(size(s));
x = og + n;         % blurred and noisy image

dtwavelet.coeff = dtwavelet.decomposition(x);
WT = dtwavelet;
WT.coeff = WT.decomposition(s);









