function [] = ShowImageColor( x, map )
%SHOWIMAGE Display the image
%   Display the 2D square image matrix in grayscale
%
%   Author: Chenzhe Diao

% figure;
if nargin ==1
    map = 'jet';
end

imagesc(x);
colormap(map);
axis image

colorbar

% [M, N] = size(x);
% set(gca,'XTick',1:16:N);
% set(gca,'YTick',1:16:M);
% grid on

impixelinfo;

end

