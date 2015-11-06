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
HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
OLD_CODE = [HOME_PATH 'old_code'];
path(pathdef);
addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));


%% Input: Choose Picture (in HOME_PATH/Pics/)
imgName    = 'Lena512.png';
% imgName    = '1.5.07.tiff';

s = double(imread(imgName));


%% Input: Choose Transform
Transform = 'DT';
% Transform = 'DT_SplitHigh';
% Transform = 'DT_SplitHighLow';
% Transform = 'DT_SplitHighLowComplex';

nlevel = 4;

fprintf('Denoising using Transform: %s, for %d levels...\n', Transform, nlevel);

% load filters
% [FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
[FS_filter1d, fb1d] = DualTree_FilterBank_Zhao;
% [FS_filter1d, fb1d] = DualTree_FilterBank_test;
% [FS_filter1d, fb1d] = DualTree_FilterBank;

%% Initial Filter Bank

trow = 110;
cdrow = 215;

Best_Table = ones(trow, 5)*inf;     % t1, t2, bestc1, bestd1, PSNR_val
tcount = 1;
for t2 = 3;
for t1 = -2*t2-2:0.2:-2*t2 + 2*sqrt(t2)

% % t1 = 1-t2;

tmp_list = ones(cdrow, 3)*inf;      % c1, d1, PSNR_val
cdcount = 1;
for c1 = -0.5:0.1:0.5;
for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2);

[az, uz] = InitialLowpass(t1, t2);
[b1, b2] = InitialHighpass(uz, c1, d1);

FS_filter1d{1}(1) = az;
FS_filter1d{1}(2) = sqrt(2).* b1;
FS_filter1d{2}(1) = az;
FS_filter1d{2}(1).start_pt = az.start_pt+1;
FS_filter1d{2}(2) = sqrt(2).* b2;


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
% load('noise512_new.mat','noise512');
sigmaN = 5;  % noise level
len = length(sigmaN);


%% Denoising
% PSNR_val = zeros(1, len);

% fprintf('\nDenoising the image: %s', imgName);
% fprintf('\nNoise level: %s\n', mat2str(sigmaN));
% disp('PSNR = ');

for i = 1   % choose noise levels
    
    sigma = sigmaN(i);
    
    rng(0,'v4');
    n = sigmaN(i)*randn(size(s));
    
    x = s + n;
    
    y = denoise_BiShrink(x, nlevel, sigma, FS_filter1d, fb1d, nor, Transform, u_hi, u_low);
    

    
    % Calculate the PSNR value
    PSNR_val = PSNR(s,y);
    
%     cprintf('blue','    %g', PSNR_val(i));
end

tmp_list(cdcount, 1) = c1;
tmp_list(cdcount, 2) = d1;
tmp_list(cdcount, 3) = PSNR_val;

cdcount = cdcount + 1;

end % for d1
end % for c1

tmpobj = tmp_list(:,3);
[bestPSNR, ind] = max(tmpobj);
bestc1 = tmp_list(ind, 1);
bestd1 = tmp_list(ind, 2);

Best_Table(tcount, 1) = t1;
Best_Table(tcount, 2) = t2;
Best_Table(tcount, 3) = bestc1;
Best_Table(tcount, 4) = bestd1;
Best_Table(tcount, 5) = bestPSNR;

tcount = tcount + 1;

if mod(tcount, 10)==0
    fprintf('\n tcount = %d, t1=%f, t2=%f', tcount, t1, t2);
end

end % for t1
end %for t2

save('Best_Table2.mat');


%%

% count = 0;
% for t2 = 2.9:0.1:3
%     for t1 = -2*t2-2:0.1:-2*t2 + 2*sqrt(t2)
% %         for c1 = -0.5:0.1:0.5;
% %             for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2);
%                 count = count+1;
% %             end
% %         end
%     end
% end









