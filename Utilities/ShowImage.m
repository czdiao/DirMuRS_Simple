function [] = ShowImage( x )
%SHOWIMAGE Display the image
%   Display the 2D square image matrix in grayscale
%
%   Author: Chenzhe Diao

% figure;
imagesc(x);
colormap(gray);
axis image

colorbar

% [M, N] = size(x);
% set(gca,'XTick',1:16:N);
% set(gca,'YTick',1:16:M);
% grid on

impixelinfo;

end

