function [varargout] = plot_freq( img )
%PLOT_FREQ Plot the image in frequency domain.
%
%
%   Chenzhe
%   Feb, 2016
%

[len1, len2] = size(img);

dx = 2*pi/len1;
dy = 2*pi/len2;

if mod(len1, 2)==0
    x = linspace(-pi,pi-dx,len1);
else
    x = linspace(-pi+dx/2,pi-dx/2, len1);
end

if mod(len2, 2)==0
    y = linspace(-pi,pi-dy,len2);
else
    y = linspace(-pi+dy/2,pi-dy/2, len2);
end

m = mean(img(:));
img = img-m;
z = log(abs(fft2(img)));
z = fftshift(z);

if nargout ~= 0
    varargout{1} = z;
end


% figure;
[X, Y] = meshgrid(x, y);
mesh(Y, X, z/1);
axis image;
colormap(jet)

xlim([-pi,pi]); ylim([-pi, pi]);
set(gca,'XTick',linspace(-pi,pi,5));
set(gca,'YTick',linspace(-pi,pi,5));
set(gca,'LineWidth',3);
set(gca,'GridLineStyle','-');
set(gca, 'GridColor', 'k');
grid on;
xlabel('Dimension 1');
ylabel('Dimension 2');
view(90, 90);
colorbar;


end

