function [] = ShowImage_shift( x )
%SHOWIMAGE_SHIFT Display the shifted image
%   Display the 2D square image matrix in grayscale, shifted by half
%   period.

[M, N] = size(x);

x = circshift2d(x, M/2, N/2);

figure;
imagesc(x);
colormap(gray);
axis image
set(gca,'XTick',1:16:N);
set(gca,'YTick',1:16:M);
grid on

end

