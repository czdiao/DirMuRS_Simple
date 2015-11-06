%% Plot DAS in Time Domain
clear;

nlevel = 2;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);


[FS_filter1d, FilterBank1d] = DualTree_FilterBank_Zhao;

%% Initial Filter Bank
t2 = 3;

% t1 = -2*t2-2;
% c1 = 0.37;
% d1 = 0.35;

t1 = -2*t2 + 2*sqrt(t2);
% % t1 = 1-t2;
c1 = 0.37;
d1 = 0.35;

[az, uz] = InitialLowpass(t1, t2);
[b1, b2] = InitialHighpass(uz, c1, d1);

FS_filter1d{1}(1) = az;
FS_filter1d{1}(2) = sqrt(2).* b1;
FS_filter1d{2}(1) = az;
FS_filter1d{2}(1).start_pt = az.start_pt+1;
FS_filter1d{2}(2) = sqrt(2).* b2;

%%
% To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];
% u_low = exp(1i*pi/4).*u_low;

% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];
% u_hi = exp(1i*pi/4).*u_hi;



%% Transform
% w = DualTree2d_SplitHighLowComplex(x, nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
w = DualTree2d(x, nlevel, FS_filter1d, FilterBank1d);


J = 1;  % level to plot DAS
N = L/2^J;  % center position


nband = length(w{1}{1}{1});

% pos = [3,4,7,8,9,10,13,14,11,12,15,16];
% figure;

for iband = 1:nband
        
    for d2 = 1:1
        % Imaginary
        d1 = mod(d2,2)+1;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y1 = iDualTree2d_SplitHighLowComplex(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
        y1 = iDualTree2d(w,nlevel, FS_filter1d, FilterBank1d);

        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
%         subplot_tight(4,4,pos(iband));
        figure;ShowImage(y1);
        
        % Real
%         d1 = d2;
%         w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y2 = iDualTree2d_SplitHighLow(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
%         w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
%         y_mag = sqrt(y1.^2 + y2.^2);
%         figure;ShowImage(y_mag);
        
    end
    
end









