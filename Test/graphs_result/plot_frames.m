clear;

nlevel = 5;     % level of decomposition
L = 4*2^(nlevel+1);

x = zeros(L,L);
filter = Daubechies8_2d;
w = Framelet2d(x, nlevel, filter);



J = 5;  % level to plot DAS
N = L/2^J;

% figure(1);

count = 0;
for nband = 1:3
        
        w{J}{nband}(N/2, N/2) = 1;
        y1 = iFramelet2d(w,nlevel, filter);

        w{J}{nband}(N/2, N/2) = 0;
        ShowImage(y1)

end






