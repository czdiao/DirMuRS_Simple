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
imgName    = 'Barbara512.png';
s = double(imread(imgName));


%% Input: Choose Transform
Transform = 'DT';   %   DT, DT_SplitHigh, DT_SplitHighLow
% Transform = 'DT_SplitHigh';
% Transform = 'DT_SplitHighLow';

switch Transform
    case('DT')
        [FS_filter2d, filter2d] = DualTreeFilter2d;
        load('nor_DT_6level.mat', 'nor');
        split_low = false;
    case('DT_SplitHigh')
        [FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
        load('nor_SplitHigh.mat', 'nor');
        split_low = false;
    case('DT_SplitHighLow')
        [FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
%         load('nor_SplitHighLow.mat', 'nor');
        split_low = true;
end

% [FS_filter1d,FilterBank1d] = DualTree_FilterBank;


%% Load noise
load('noise512_new.mat','noise512');
sigmaN = [5, 10, 25, 40, 50, 80, 100];  % noise level
len = length(sigmaN);


%% Denoising
PSNR_val = zeros(1, len);

% for t1 = 0.01:0.01:2*pi
%     for t2 = 0.01:0.01:2*pi
%         for t3 = 0.01:0.01:2*pi
            
%             fprintf('t1 = %g, t2 = %g, t3 = %g:\n', t1, t2, t3);
            
%             nor = filter_norm_func(t1, t2, t3);
            
            for i = 1:7
                
                sigma = sigmaN(i);
                
                n = noise512{i};    % Saved in noise512.mat
                
                x = s + n;
                
                y = denoise_BiShrink(x, 5, sigma, FS_filter2d, filter2d, nor, split_low);
                
                %     y = denoise_BLSGSM(x,5, sigma, FS_filter2d, filter2d);
                
                % Calculate the error
                err = s - y;
                
                % Calculate the PSNR value
                PSNR_val(i) = PSNR(s,y);
%                 PSNR_val(i) = 20*log10(255/std(err(:)));
                fprintf('    %g', PSNR_val(i));
            end
            
            fprintf('\n');
            
%         end % t3
%     end % t2
% end % t1






