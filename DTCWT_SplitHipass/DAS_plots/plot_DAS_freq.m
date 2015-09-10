%% Plot DAS in Frequency Domain
clear;

nlevel = 4;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);
[FS_filter2d, filterbank2d] = DualTreeFilter2d_SplitHipass;
w = DualTree2d(x, nlevel, FS_filter2d, filterbank2d);
% w = DualTree2d_SplitLow(x, nlevel, FS_filter2d, filter2d);


J = 2;  % level to plot DAS
N = L/2^J;  % center position


count = 0;
nband = 8;
y_all = cell(1,2*nband);

for iband = 1:nband
        
    for d2 = 1:2
        % Imaginary
        d1 = mod(d2,2)+1;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y1 = iDualTree2d_SplitLow(w,nlevel, FS_filter2d, filter2d);
        y1 = iDualTree2d(w,nlevel, FS_filter2d, filterbank2d);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        % Real
        d1 = d2;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y2 = iDualTree2d_SplitLow(w,nlevel, FS_filter2d, filter2d);
        y2 = iDualTree2d(w,nlevel, FS_filter2d, filterbank2d);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        
        I = sqrt(-1);
        yt = y2 + I*y1;
        yf = fftshift(abs(fft2(yt)));
        
        count = count +1;
        y_all{count} = yf;
    end
    
end


for i = 1:2*nband
    surf(4*y_all{i}); axis image;
    hold on;
end





