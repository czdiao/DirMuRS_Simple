%% Plot DAS in Time Domain
clear;

nlevel = 4;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);


[FS_filter1d, FilterBank1d] = DualTree_FilterBank_Selesnick;

% To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];

% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];

w = DualTree2d_SplitHighLow(x, nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);


J = 2;  % level to plot DAS
N = L/2^J;  % center position


nband = length(w{1}{1}{1});

for iband = 1:nband
        
    for d2 = 1:1
        % Imaginary
        d1 = mod(d2,2)+1;
        w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
        y1 = iDualTree2d_SplitHighLow(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
        w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
%         figure;ShowImage(y1)
        
        % Real
%         d1 = d2;
%         w{J}{d1}{d2}{iband}(N/2, N/2) = 1;
%         y2 = iDualTree2d_SplitHighLow(w,nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
%         w{J}{d1}{d2}{iband}(N/2, N/2) = 0;
        
%         y_mag = sqrt(y1.^2 + y2.^2);
%         figure;ShowImage(y_mag);
        
    end
    
end









