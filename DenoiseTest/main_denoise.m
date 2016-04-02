%% Main test script to test the denoising algorithms
%
%   This uses the WaveletData2D class interface.
%   Support the local soft and bishrink denoise algorithm
%
%   Chenzhe
%   Jan, 2016

%% Set Home Path and Add to Path
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% OLD_CODE = [HOME_PATH 'old_code'];
% path(pathdef);
% addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));

clear;

%% Input: Choose Picture (in HOME_PATH/Pics/)
imgName    = 'fingerprint.png';
% imgName    = '1.5.07.tiff';


s = double(imread(imgName));

%% Input: Set up Transform Details

%%load filter banks
% [FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
% [FS_filter1d, fb1d] = DualTree_FilterBank_Zhao;
% [FS_filter1d, fb1d] = DualTree_FilterBank_test;
% [FS_filter1d, fb1d] = DualTree_FilterBank;


% fb = CTF3_FilterBank_freq(1024);
% fb = CTF6_FilterBank_freq(1024);
% fb(1) = add(fb(1), fb(2));
% fb(2) = [];

fb2d = CTF6_FilterBank_freq2D(1024);
% fb2d = CTFAdaptiveTest_FilterBank_freq2D(1024);
% fb2d = CTF13AdaptiveTest_FilterBank_freq2D(1024);
% fb2d(1).rate = 2;


% fb2d = CTFblock_FilterBank_freq2D(1024);
% fb2d(2:end) = FFBEnergyCal(fb2d(2:end), s);
% ffbindex = FFBindex(12, 12, fb2d(2:end));
% figure;ShowImage((ffbindex.EnergyMatrix))
% Group = FBGroup(ffbindex);
% fb2d_new = FBCombineGroup(Group, fb2d(2:end));
% fb2d = [fb2d(1), fb2d_new];
% fprintf('\nFinished Generating Filter Bank!\n');


%%To split lowpass
% [u1, u2] = SplitLowOrig;
% u_low = [u1, u2];

%%To split highpass
% [u1, u2] = SplitHaar;
% u_hi = [u1, u2];
% u_hi = Daubechies8_1d;

nL = 5;     % decomposition levels
% dtwavelet = DualTreeSplitHighLow2D(FS_filter1d, fb1d, u_hi, u_low);
dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
% dtwavelet = fFrameletTransform2D(fb);
% dtwavelet = fFrameletCrossLv2D(fb);
dtwavelet.level_norm = nL;
dtwavelet.nlevel = nL;
dtwavelet.nor = dtwavelet.CalFilterNorm;

%% Denoise

sigmaN = [5, 10, 25, 40, 50, 80, 100];  % noise level
len = length(sigmaN);

PSNR_val = zeros(1, len);

fprintf('\nDenoising the image:');
cprintf('blue','    %s', imgName);
fprintf('\nTransform type:');
cprintf('blue','    %s', dtwavelet.type);

fprintf('\nNoise level: %s\n', mat2str(sigmaN));
disp('PSNR = ');

tic;
count = 0;
for i = 1:len   % choose noise levels
    
    Nsig = sigmaN(i);
    rng(0,'v4');
    n = Nsig*randn(size(s));
    x = s + n;
    
%     y = denoise_localsoft(x, Nsig, dtwavelet, s);
    y = denoise_bishrink(x, Nsig, dtwavelet);
    
    y = y.*(y>=0);
    
    % Calculate the PSNR value
    PSNR_val(i) = PSNR(s,y);
    
    cprintf('blue','    %g', PSNR_val(i));
    count = count + 1;
end
fprintf('\n');

AverageTime = toc/count;
fprintf('\nAverage time for denoising %d noisy pictures is %f seconds.\n\n', count, AverageTime);












