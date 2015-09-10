%% Plot DAS in Frequency Domain for Freq Transforms
clear;

nlevel = 4;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);

[FS_filter1d, FilterBank1d] = DualTree_FilterBank_freq(L);

w = fDualTree2d_SplitHighLow(x, nlevel, FS_filter1d, FilterBank1d);


J = 2;  % level to plot DAS
N = L/2^J;  % center position


count = 0;
nband = length(w{1}{1}{1});
y_all = cell(1,2*nband);


for iband = 1:nband
        
    for d2 = 1:1
        % Imaginary
        d1 = mod(d2,2)+1;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
        y1 = ifDualTree2d_SplitHighLow(w,nlevel, FS_filter1d, FilterBank1d);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        % Real
        d1 = d2;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
        y2 = ifDualTree2d_SplitHighLow(w,nlevel, FS_filter1d, FilterBank1d);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        
        I = sqrt(-1);
        yt = y2 + I*y1;
        yf = fftshift(abs(fft2(yt)));
        
        count = count +1;
        y_all{count} = yf;
    end
    
end


for i = 1:nband
%     figure;
    surf(10*y_all{i}); axis image;view(0, 90);
    hold on;
end
view(0, 90)
tightfig;



