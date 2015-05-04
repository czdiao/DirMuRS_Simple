% Main function
% Usage :
%        main_dtdwt
% INPUT :
%        Raw Lena image
% OUTPUT :
%        PSNR value of the denoised image


clear;


imgName    = 'pics/Barbara512.png';
s = double(imread(imgName));


% Add noise 
load noise512.mat

sigmaN = [5, 10, 25, 40, 50, 80, 100];
len = length(sigmaN);



[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
% [FS_filter2d, filter2d] = DualTreeFilter2d;


% tt=2.0:0.2:10.0;
% ttlen = length(tt);

% sk = 1.6:0.1:2.2;
% sklen = length(sk);

% PSNR_matrix = zeros(sklen, ttlen, len);

PSNR = zeros(1, len);


%     fprintf('tt = %g:\n', tt);
    for i = 3:3
        %             fprintf('i = %d\n', i);
        sigma = sigmaN(i);
        n = noise512{i};
        
        x = s + n;
        

        % Run local adaptive image denoising algorithm using dual-tree DWT.
%         y = denoise_DualTree2d(x, 5, sigma, FS_filter2d, filter2d, 6);

        y = denoise_BLSGSM(x,5, sigma, FS_filter2d, filter2d);
        
        % Calculate the error
        err = s - y;
        
        %             PSNR_matrix(isk, itt, i) = 20*log10(255/std(err(:)));
        
        % Calculate the PSNR value
        PSNR(i) = 20*log10(255/std(err(:)));
        fprintf('    %g', PSNR(i));
    end
    fprintf('\n');

fprintf('\n\n');








