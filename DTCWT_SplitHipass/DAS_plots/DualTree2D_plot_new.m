clear;

nlevel = 3;
L = 4*2^(nlevel+1);
N = L/2^nlevel * 2;

x = zeros(L,L);
[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
% w = DualTree2d(x, nlevel, FS_filter2d, filter2d);
w = DualTree2d_SplitLow(x, nlevel, FS_filter2d, filter2d);




y_all = cell(1,24);

J = 1;

% figure(1);

count = 0;
for nband = 1:12
        
    for d2 = 2:2
        % Imaginary
        d1 = mod(d2,2)+1;
        w{J}{d1}{d2}{nband}(N/2, N/2) = 1;
        y1 = iDualTree2d_SplitLow(w,nlevel, FS_filter2d, filter2d);
%         y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);

        w{J}{d1}{d2}{nband}(N/2, N/2) = 0;
%         ShowImage(y1)
        
        % Real
        d1 = d2;
        w{J}{d1}{d2}{nband}(N/2, N/2) = 1;
        y2 = iDualTree2d_SplitLow(w,nlevel, FS_filter2d, filter2d);
%         y2 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);

        w{J}{d1}{d2}{nband}(N/2, N/2) = 0;
%         ShowImage(y2); title('Original DT Split Highpass');
        
        y_mag = sqrt(y1.^2 + y2.^2);
        % ShowImage(y_mag);
        
        I = sqrt(-1);
        yt = y2 + I*y1;
        yf = fftshift(abs(fft2(yt)));
        
        count = count +1;
        y_all{count} = yf;
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

figure(1);

for i = 1:12
    surf(4*y_all{i}); axis image;
    hold on;
end





