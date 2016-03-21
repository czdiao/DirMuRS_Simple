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
% imgName    = '1.2.08.tiff';
% imgName    = 'Pressed calf leather.tiff';
% imgName    = '1.1.03.tiff';
imgName    = 'Barbara512.png';

s = double(imread(imgName));
% s(511,:) = s(510,:);
% s(512,:) = s(510,:);
% s = symrotate(s,45);


%% Input: Choose Transform
% Transform = 'DT';   %   DT, DT_SplitHigh, DT_SplitHighLow
% Transform = 'DT_SplitHigh';
Transform = 'DT_SplitHighLow';

[FS_filter1d, filterbank1d] = DualTree_FilterBank_freq(1024);
% [FS_filter1d, filterbank1d] = DualTree_FilterBank_freq(1024);


switch Transform
    case('DT')
        load('nor_DT_freq.mat', 'nor');
    case('DT_SplitHigh')
        load('nor_SplitHigh_freq.mat', 'nor');
    case('DT_SplitHighLow')
        load('nor_DT_SplitHL_freq.mat', 'nor');

end



%% Load noise
load('noise512_new.mat','noise512');
sigmaN = [5, 10, 25, 40, 50, 80, 100];  % noise level
len = length(sigmaN);


%% Denoising
PSNR_val = zeros(1, len);



for i = 1:len
    
    sigma = sigmaN(i);
    
    n = noise512{i};    % Saved in noise512.mat
    
    x = s + n;
    
    y = denoise_BiShrink_freq(x, 6, sigma, FS_filter1d, filterbank1d, nor, Transform);
        
    % Calculate the error
    err = s - y;
    
    % Calculate the PSNR value
    PSNR_val(i) = PSNR(s,y);
    %                 PSNR(i) = 20*log10(255/std(err(:)));
    fprintf('    %g', PSNR_val(i));
end

fprintf('\n');







