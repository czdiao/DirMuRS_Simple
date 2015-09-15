%% Plot DAS in Frequency Domain
clear;

nlevel = 4;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);


% [FS_filter1d, FilterBank1d] = DualTree_FilterBank_Selesnick;
% [FS_filter1d, FilterBank1d] = DualTree_FilterBank_test;
[FS_filter1d, FilterBank1d] = DualTree_FilterBank;



% To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];
% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];

% w = DualTree2d_new(x, nlevel, FS_filter1d, FilterBank1d);
w = DualTree2d_SplitHighLow(x, nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);


J = 1;  % level to plot DAS
N = L/2^J;  % center position


count = 0;
nband = 12;
y_all = cell(1,2*nband);
Energy = zeros(1, 2*nband);

for iband = 1:nband
        
    for d2 = 1:1
        % Imaginary
        d1 = mod(d2,2)+1;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
        y1 = iDualTree2d_SplitHighLow(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        % Real
        d1 = d2;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y2 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
        y2 = iDualTree2d_SplitHighLow(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);

        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        
        I = sqrt(-1);
        yt = y2 + I*y1;
        yf = fftshift(abs(fft2(yt)));
        
        count = count +1;
        y_all{count} = yf;
        Energy(count) = sum(sum(abs(yt).^2));
    end
    
end

figure
colormap(jet)


for i = 1:nband
%     figure;
    surf(10*y_all{i}); axis image;view(0, 90);%tightfig;
    hold on;
    pause(0.7);
end
view(0, 90)
% tightfig;


