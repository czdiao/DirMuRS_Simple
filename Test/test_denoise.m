
%% Add Path
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% addpath(genpath(HOME_PATH));

clear;

%% Load Noise
sigmaN = [5, 10, 30, 50, 80, 100];
len = length(sigmaN);
load('noise_thresh.mat','noise512');

%% Load Image
imgName    = 'Lena512.png';
x = double(imread(imgName));

%% Load Filter
filter = Daubechies8_1d;
load('nor_daubechies8.mat','nor');
nlevel = 5; %5

PSNR_val = zeros(len, 1);
%% Denoising
for i = 1:len
    n = noise512{i};
    s = x + n;

    y = DenoiseLocalSoft(s, nlevel, sigmaN(i), filter, nor,x);
%     y = DenoiseBishrink(s, nlevel, sigmaN(i), filter, nor);
    
    
    % Calculate the PSNR value
    PSNR_val(i) = PSNR(x, y);
    fprintf('    %g', PSNR_val(i));

    
end
fprintf('\n');



%% Optimal Vetterli Const
% i = 7;
% n = noise512{i};
% s = x + n;
% 
% for Thr_C = 0.9:0.1:1.9
%     y = DenoiseVetterli(s, nlevel, sigmaN(i), filter, Thr_C);
%     err = x - y;
%     
%     PSNR = 20*log10(255/std(err(:)));
%     fprintf('Thr_C = %g\t PSNR = %g\n', Thr_C,PSNR);
% end








