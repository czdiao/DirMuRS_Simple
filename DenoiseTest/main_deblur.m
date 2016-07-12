%% Main test script to test the deblur algorithms
%
%   This uses the WaveletData2D class interface.
%
%   Chenzhe
%   April, 2016


clear;

%% Input: Choose Picture (in HOME_PATH/Pics/)
% imgName    = 'goldhill256.png';
imgName     ='Lena512.png';
% imgName     ='Lena512.png';
% imgName    = '1.5.07.tiff';


s = double(imread(imgName));

%% old input:
% Input: Set up Filter Bank Details
% 
% %%load filter banks
% % [FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
% % [FS_filter1d, fb1d] = DualTree_FilterBank_Zhao;
% % [FS_filter1d, fb1d] = DualTree_FilterBank_test;
% % [FS_filter1d, fb1d] = DualTree_FilterBank;
% 
% 
% % fb = CTF3_FilterBank_freq(1024);
% % fb = CTF6_FilterBank_freq(1024);
% % fb(1) = add(fb(1), fb(2));
% % fb(2) = [];
% % fb = SplineCubic1d;
% % fb = SplineLinear1d;
% 
% fb2d = CTF6_FilterBank_freq2D(1024);
% % fb2d = CTFAdaptiveTest_FilterBank_freq2D(1024);
% % fb2d = CTF13AdaptiveTest_FilterBank_freq2D(1024);
% % fb2d(1).rate = 2;
% 
% 
% % fb2d = CTFblock_FilterBank_freq2D(1024);
% % fb2d(2:end) = FFBEnergyCal(fb2d(2:end), s);
% % ffbindex = FFBindex(12, 12, fb2d(2:end));
% % figure;ShowImage((ffbindex.EnergyMatrix))
% % Group = FBGroup(ffbindex);
% % fb2d_new = FBCombineGroup(Group, fb2d(2:end));
% % fb2d = [fb2d(1), fb2d_new];
% % fprintf('\nFinished Generating Filter Bank!\n');
% 
% 
% %%To split lowpass
% % [u1, u2] = SplitLowOrig;
% % u_low = [u1, u2];
% 
% %%To split highpass
% % [u1, u2] = SplitHaar;
% % u_hi = [u1, u2];
% % u_hi = Daubechies8_1d;

% Input: Set up Transform Details
% nL = 4;   %4;     % decomposition levels
% % % dtwavelet = DualTreeSplitHighLow2D(FS_filter1d, fb1d, u_hi, u_low);
% dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
% % % dtwavelet = fFrameletTransform2D(fb);
% % % dtwavelet = fFrameletCrossLv2D(fb);
% % % dtwavelet = FrameletUndec2D(fb);
% dtwavelet.level_norm = nL;
% dtwavelet.nlevel = nL;
% dtwavelet.nor = dtwavelet.CalFilterNorm;


%% Input Type: SplineFilter with undecimated transform
% % fb = SplineCubic1d;
% fb = SplineLinear1d;
% nL = 4;     % decomposition levels
% dtwavelet = FrameletUndec2D(fb);
% dtwavelet.level_norm = nL;
% dtwavelet.nlevel = nL;
% dtwavelet.nor = dtwavelet.CalFilterNorm;
% 
% % sigmaN = [5, 10, 25, 40, 50, 80, 100];  % noise level
% % len = length(sigmaN);

%% Input Type: TPCTF6 filter bank
fb2d = CTF6_FilterBank_freq2D(512);
nL = 5;   %4;     % decomposition levels
dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
dtwavelet.level_norm = nL;
dtwavelet.nlevel = nL;
% dtwavelet.nor = dtwavelet.CalFilterNorm;


%% Set up the blur kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ker = fspecial('average', 9);
ker = fspecial('motion', 15, 30);
% ker = fspecial('gaussian', 15, 1.5);
% H = fspecial('gaussian',HSIZE,SIGMA)
% ker = fspecial('disk', 7);
% ker = 1;   % test for denoising

tol=1e-3;
blur=@(f,k)imfilter(f,k,'circular');    % this is the circular convolution of f with k(-x), the zero position of f 
og=blur(s,ker);     % blurred image

Nsig = 3;

rng(0,'v4');      % used previously, 2 lines below are used by Cai's code
% rand('seed',3000);
% randn('seed',3000);

n = Nsig*randn(size(s));
x = og + n;         % blurred and noisy image
fprintf('\nNoise level: %s\n', num2str(Nsig));
fprintf('\nOriginal PSNR = %f\n', PSNR(s, x));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Input Type: Angular Filter Bank in frequency domain
% fb2d = GenAngular_FB_freq2D_disk(ker, 512);
% fb2d = Angular_FilterBank_freq2D( linspace(pi/8,6*pi/8,4), 8, 512 );
% fb2d  = GenAngular_FB_freq2D_gaussian( ker, 512 );

% nL = 1;      % decomposition levels
% dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
% dtwavelet.level_norm = nL;
% dtwavelet.nlevel = nL;
% dtwavelet.nor = dtwavelet.CalFilterNorm;
% 
% fprintf('\nDeblurring the image:');
% cprintf('blue','    %s\n', imgName);

%% Input Type: Square Filter Bank in frequency domain
% fb2d = GenSquare_FB_freq2D_average(ker, 2, 512);
% 
% nL = 1;      % decomposition levels
% dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
% dtwavelet.level_norm = nL;
% dtwavelet.nlevel = nL;
% dtwavelet.nor = dtwavelet.CalFilterNorm;
% 
% fprintf('\nDeblurring the image:');
% cprintf('blue','    %s\n', imgName);


%% Deblur

tic;
% y = deblur_L1_analysis(x, ker, blur, Nsig, dtwavelet, s );
y  = deblur_freq_decomp( x, ker, dtwavelet, Nsig, s  );

y = real(y);
y = y.*(y>=0);
AverageTime = toc;

% Calculate the PSNR value
PSNR_val = PSNR(s,y);

cprintf('blue','    %g', PSNR_val);
fprintf('\n');
fprintf('\nAverage time for denoising noisy pictures is %f seconds.\n\n', AverageTime);


% figure;
% subplot_tight(1,3,1); ShowImage(s);
% subplot_tight(1,3,2); ShowImage(x);
% subplot_tight(1,3,3); ShowImage(y);
% t = num2str(PSNR_val);
% title(['PSNR = ' t] );
% linkaxes;


% figure;
% subplot_tight(1,2,1); ShowImage(x);
% subplot_tight(1,2,2); ShowImage(y);
% t = num2str(PSNR_val);
% title(['PSNR = ' t] );
% linkaxes;

%% plot kernel

ker = fspecial('motion', 15, 30);

% ker = fspecial('disk', 7);
% ker = fspecial('average', 7);
% ker = fspecial('gaussian', 15, 1.5);
ker_fullsize = zeros(512);
[M, N] = size(ker);
ker_fullsize(1:M, 1:N) = ker;
fker = abs(fft2(ker_fullsize));
filtertmp = freqfilter2d;
filtertmp.ffilter = fker;
filtertmp.plot_ffilter
% % figure; mesh(fker)
% figure; mesh(log(fftshift(fker)))
tmp = fker(1,:);
f1d = freqfilter1d;
f1d.ffilter = (tmp);
figure; f1d.plot_ffilter

% fker = abs(fft2(ker_fullsize));
% fkerfilter = freqfilter2d;
% fkerfilter.ffilter = fker;
% % fkerfilter.plot_ffilter
% tmp = fker(1,:);
% fkerfilter1 = freqfilter1d;
% fkerfilter1.ffilter = tmp;
% figure;
% fkerfilter1.plot_ffilter


%% plot fb2d
% [M1, N1] = size(x);
% [M2, N2] = size(fb2d(1).ffilter);
% fb2d = fb2d.filterdownsample(M2/M1, N2/N1);
% fb2d.plot_ffilter;








