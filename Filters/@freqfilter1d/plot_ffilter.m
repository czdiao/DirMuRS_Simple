function plot_ffilter(obj, varargin)
%PLOT_FFILTER Plot filter in frequency domain. Plot \xi in [-pi, pi].
%
%
%   Chenzhe
%   July, 2015
%



Nfilters = length(obj);
for i = 1:Nfilters
    len = length(obj(i).ffilter);
    dx = 2*pi/len;
    if mod(len, 2)==0
        x = linspace(-pi,pi-dx,len);
    else
        x = linspace(-pi+dx/2,pi-dx/2, len);
    end
    
    y = fftshift(abs(obj(i).ffilter));
    %                 figure;
    plot(x, y, varargin{:}); xlim([-pi,pi]); hold on;
    set(gca,'XTick',linspace(-pi,pi,5)); grid on;
    pause(0.5);
end


end

