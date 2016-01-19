%% Plot DAS in Frequency Domain
clear;

nlevel = 3;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);


% [FS_filter1d, FilterBank1d] = DualTree_FilterBank_Selesnick;
% [FS_filter1d, FilterBank1d] = DualTree_FilterBank_test;
[FS_filter1d, FilterBank1d] = DualTree_FilterBank_Zhao;


%%
% t2 = 3;
% 
% t1 = -2*t2-2;
% % c1 = 0.37;
% % d1 = 0.35;
% 
% % t1 = -2*t2 + 2*sqrt(t2);
% % % t1 = 1-t2;
% c1 = 0.37;
% d1 = 0.35;
% 
% [az, uz] = InitialLowpass(t1, t2);
% [b1, b2] = InitialHighpass(uz, c1, d1);
% 
% FS_filter1d{1}(1) = az;
% FS_filter1d{1}(2) = sqrt(2).* b1;
% FS_filter1d{2}(1) = az;
% FS_filter1d{2}(1).start_pt = az.start_pt+1;
% FS_filter1d{2}(2) = sqrt(2).* b2;




%%
% To split lowpass
[u1, u2] = SplitLowOrig;
% [u1, u2] = SplitULen3(0.2, 1);
u_low = [u1, u2];
u_low = exp(1i*pi/4).*u_low;
% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];
u_hi = exp(1i*pi/4).*u_hi;


[u1, u2] = SplitULen3(-0.2, pi);
u_hi = [u1, u2];

[u1, u2] = SplitULen3(0.2, 1);
u_low = [u1, u2];



w = DualTree2d_SplitHighLowComplex(x, nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
% w = DualTree2d(x, nlevel, FS_filter1d, FilterBank1d);

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
%         y1 = iDualTree2d(w,nlevel, FS_filter1d, FilterBank1d);
        y1 = iDualTree2d_SplitHighLowComplex(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        % Real
        d1 = d2;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y2 = iDualTree2d(w,nlevel, FS_filter1d, FilterBank1d);
        y2 = iDualTree2d_SplitHighLowComplex(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);

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


