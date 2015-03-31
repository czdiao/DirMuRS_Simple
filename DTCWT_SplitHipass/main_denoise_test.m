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


imgName    = 'pics/Lena512.png';
s = double(imread(imgName));


% Add noise 
%SIGMANS = 5:5:100;%[5,10,15,20,25,30,50];  % Noise standard deviation
% randn('seed',0);
sigmaN = [5, 10, 25, 40, 50, 80, 100];
len = length(sigmaN);


load noise512.mat

[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;


PSNR = zeros(1, len);

for i = 1:len
    
    sigma = sigmaN(i);
    n = noise512{i};
    
    
    %n = sigma*randn(size(s));
    x = s + n;
    
    % Run local adaptive image denoising algorithm using dual-tree DWT.
    y = denoise_DualTree2d(x,5, sigma, FS_filter2d, filter2d);
    
    % Calculate the error
    err = s - y;
    
    % Calculate the PSNR value
    PSNR(i) = 20*log10(255/std(err(:)))
    
end



% ShowImage(s)
% ShowImage(n)
% ShowImage(x)
% ShowImage(y)
% ShowImage(err)




