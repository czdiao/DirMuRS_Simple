function [] = ShowImage( x )
%SHOWIMAGE Display the image
%   Display the 2D square image matrix in grayscale

figure;
imagesc(x);
colormap(gray);
axis image


end

