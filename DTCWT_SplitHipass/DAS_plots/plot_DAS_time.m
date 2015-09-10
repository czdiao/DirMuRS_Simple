%% Plot DAS in Time Domain
clear;

nlevel = 4;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);
[FS_filter2d, filterbank2d] = DualTreeFilter2d_SplitHipass;
% w = DualTree2d(x, nlevel, FS_filter2d, filterbank2d);
w = DualTree2d_SplitLow(x, nlevel, FS_filter2d, filterbank2d);


pp = [14, 10, 13, 9 ,8, 7, 6, 5, 4, 3, 2, 1];


J = 4;  % level to plot DAS
N = L/2^J;  % center position


nband = 12;

for iband = 1:nband
        
    for d2 = 1:2
        % Imaginary
        d1 = mod(d2,2)+1;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
        y1 = iDualTree2d_SplitLow(w,nlevel, FS_filter2d, filterbank2d);
%         y1 = iDualTree2d(w,nlevel, FS_filter2d, filterbank2d);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
%         ShowImage(y1)
        
        % Real
        d1 = d2;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
        y2 = iDualTree2d_SplitLow(w,nlevel, FS_filter2d, filterbank2d);
%         y2 = iDualTree2d(w,nlevel, FS_filter2d, filterbank2d);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        subplot(4, 4, pp(iband)); ShowImage(y2);
        
        y_mag = sqrt(y1.^2 + y2.^2);
        % ShowImage(y_mag);
        
    end
    
end


% y_freq = fft2(yt);
% y_freq_abs = abs(y_freq);
% shape_norm = y_freq_abs/max(max(y_freq_abs));
% shape_modify = shape_norm.*shape_norm;
% y_freq_new = y_freq.*shape_modify;
% % subplot(1,2,2); ShowImage(fftshift(abs(y_freq_new))); title('Shrinked Frequency'); axis image;
% 
% yt_new = ifft2(y_freq_new);
% 
% y2_new = real(yt_new);
% y1_new = imag(yt_new);
% 
% subplot(1,2,2);
% ShowImage(y2_new); title('Frequency Shrinked');







