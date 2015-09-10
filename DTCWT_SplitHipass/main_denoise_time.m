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
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% addpath(genpath(HOME_PATH));


%% Input: Choose Picture (in HOME_PATH/Pics/)
imgName    = 'Boat.png';
s = double(imread(imgName));


%% Input: Choose Transform
% Transform = 'DT';
Transform = 'DT_SplitHigh';
% Transform = 'DT_SplitHighLow';

nlevel = 5;

% load filters
[FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;

% To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];

% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];


nor = CalFilterNormDT2D(FS_filter1d, fb1d, nlevel, Transform, u_hi, u_low);




%% Load noise
% load('noise512_new.mat','noise512');
sigmaN = [5, 10, 25, 40, 50, 80, 100];  % noise level
len = length(sigmaN);


%% Denoising
PSNR_val = zeros(1, len);



for i = 1:len
    
    sigma = sigmaN(i);
    
%     n = noise512{i};    % Saved in noise512.mat
    rng(0,'v4');
    n = sigmaN(i)*randn(size(s));
    
    x = s + n;
    
    y = denoise_BiShrink_new(x, nlevel, sigma, FS_filter1d, fb1d, nor, Transform, u_hi, u_low);
    
    %     y = denoise_BLSGSM(x,5, sigma, FS_filter2d, filter2d);

    
    % Calculate the PSNR value
    PSNR_val(i) = PSNR(s,y);
    
    fprintf('    %g', PSNR_val(i));
end

fprintf('\n');








