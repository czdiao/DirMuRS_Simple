% Main function
% Usage :
%        main_dtdwt
% INPUT :
%        Raw Lena image
% OUTPUT :
%        PSNR value of the denoised image
%
% Load clean image
%fid = fopen('Barbara512.png','r');
%s  = fread(fid,[512 512],'unsigned char');
%fclose(fid);
%N = 512;

clear;


imgName    = 'pics/Barbara512.png';
s = double(imread(imgName));


% Add noise 
%SIGMANS = 5:5:100;%[5,10,15,20,25,30,50];  % Noise standard deviation
% randn('seed',0);
sigmaN = [5, 10, 25, 40, 50, 80, 100];
len = length(sigmaN);


load noise512.mat

% [FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
[FS_filter2d, filter2d] = DualTreeFilter2d;


PSNR = zeros(1, len);


% tt = [10.4, 6.0, 17.4, 38.5];
tt = 6.0 * ones(1, 4);

% tt = [8.5, 5.0, 2.9, 6.0];
% tt(1) = 6.8;
% tt(2) = 4.3;
% tt(3) = 9.5;
% tt(4) = 17.5;
dlen = 11;
PSNRresult = zeros(1, dlen);

for i = 1:len
    
    sigma = sigmaN(i);
    n = noise512{i};
    
    
    %n = sigma*randn(size(s));
    x = s + n;
    
    %     for j=1:dlen
    % Run local adaptive image denoising algorithm using dual-tree DWT.
    y = denoise_DualTree2d(x, 5, sigma, FS_filter2d, filter2d, tt);
    
    % Calculate the error
    err = s - y;
    
    % Calculate the PSNR value
    PSNR(i) = 20*log10(255/std(err(:)));
    g = sprintf('%g   ', PSNR);
    fprintf('PSNR =\n %s\n', g);
    
    %         PSNRresult(j) = 20*log10(255/std(err(:)))
    %         tt(4) = tt(4) + 0.2;
    %     end
end



% ShowImage(s)
% ShowImage(n)
% ShowImage(x)
% ShowImage(y)
% ShowImage(err)




