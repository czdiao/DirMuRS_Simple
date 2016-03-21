%% Main function to test the denoising of DTCWT Split Hipass
% Supported Transforms:
%   1. Original DT-CWT
%   2. DT-CWT Split Highpass
%   3. DT-CWT Split Highpass and Lowpass

% Supported Denoising Algorithms
%   1. Bivariate Shrinkage
%   2. GSM


clear;

%% Set Home Path and Add to Path
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
OLD_CODE = [HOME_PATH 'old_code'];
path(pathdef);
addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));


%% Input: Choose Picture (in HOME_PATH/Pics/)
imgName    = 'Barbara512.png';
% imgName    = '1.5.07.tiff';

s = double(imread(imgName));


%% Input: Choose Transform
% Transform = 'DT';
% Transform = 'DT_SplitHigh';
Transform = 'DT_SplitHighLow';
% Transform = 'DT_SplitHighLowComplex';

nlevel = 5;

fprintf('Denoising using Transform: %s, for %d levels...\n', Transform, nlevel);

% load filters
% [FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
[FS_filter1d, fb1d] = DualTree_FilterBank_Zhao;
% [FS_filter1d, fb1d] = DualTree_FilterBank_test;
% [FS_filter1d, fb1d] = DualTree_FilterBank;




%% Split
% To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];

% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];
% u_hi = Daubechies8_1d;


nor = CalFilterNormDT2D(FS_filter1d, fb1d, nlevel, Transform, u_hi, u_low);




%% Load noise
sigmaN = [5, 10, 25, 40, 50, 80, 100];  % noise level
len = length(sigmaN);


%% Denoising
PSNR_val = zeros(1, len);

fprintf('\nDenoising the image: %s', imgName);
fprintf('\nNoise level: %s\n', mat2str(sigmaN));
disp('PSNR = ');

tic;
count = 0;
for i = len   % choose noise levels
    
    sigma = sigmaN(i);
    
    rng(0,'v4');
    n = sigmaN(i)*randn(size(s));
    
    x = s + n;
    
    y = framelet_localsoft(x, s, nlevel, sigma, FS_filter1d, fb1d, nor, Transform, 'iter_SplitBregman_magnitude', u_hi, u_low);
    
    y = max(y, 0);
    y = min(y, 255);

    
    % Calculate the PSNR value
    PSNR_val(i) = PSNR(s,y);
    
    cprintf('blue','    %g', PSNR_val(i));
    count = count + 1;
end
fprintf('\n');

AverageTime = toc/count;
fprintf('\nAverage time for denoising %d noisy pictures is %f seconds.\n\n', count, AverageTime);











