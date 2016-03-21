function plot_ffilter(obj)
%PLOT_FFILTER Plot 2D frequency based filter in frequency domain. 
%   Plot \xi in [-pi, pi]^2.
%
%
%   Chenzhe
%   Feb, 2016
%

Nfilters = length(obj);

figure;
isFirst = true;

for i = 1:Nfilters
    [len1, len2] = size(obj(i).ffilter);
    
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
    
    z = fftshift(abs(obj(i).ffilter));

    [X, Y] = meshgrid(x, y);
    mesh(Y, X, z);hold on;
    colormap(jet)
    
    if isFirst
        xlim([-pi,pi]); ylim([-pi, pi]);
        set(gca,'XTick',linspace(-pi,pi,5));
        set(gca,'YTick',linspace(-pi,pi,5));grid on;
        xlabel('Dimension 1');
        ylabel('Dimension 2');
        view(90, 90);
        isFirst = false;
    end
    
%     pause(0.2);
end



end

