% cplxdual2D_plots
% DISPLAY 2D WAVELETS OF cplxdual2D.M

J = 6;
L = 3*2^(J+1);
N = L/2^J;

x = zeros(4*L,8*L);
[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
w = DualTree2d(x, J, FS_filter2d, filter2d);

for d1 = 1:2
    for d2 = 1:2
        for nfilter = 1:8
            row = N/2 + N*( (d1-1) + (d2-1)*2  );
            col = N/2 + (nfilter-1)*N;
            w{J}{d1}{d2}{nfilter}(row,col) = 1;
        end
    end
end

%%
y = iDualTree2d(w,J, FS_filter2d, filter2d);
%y = [y; sqrt(y(1:L,:).^2+y(L+[1:L],:).^2)];

ShowImage(y)

% figure(1)
% clf
% imagesc(y);
% title('2D Split Hipass Dual-Tree Complex Wavelets')
% axis image
% axis off
% colormap(gray(128))
% print -djpeg95 DualTreeSplitHipass2D_plots




