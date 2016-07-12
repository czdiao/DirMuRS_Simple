function plot_DAS_time( obj, scale )
%PLOT_DAS_TIME Plot the DAS in time domain.
%
%Input:
%   scale:
%       Plot the DAS at this level
%
%   Chenzhe
%   Jan, 2016
%

if scale <=4
    K = 4;      % max level of decomposition
else
    K = scale;
end
L = 8*2^K;  % size of image
x = zeros(L,L);

%% Transform
obj.nlevel = scale;
w = obj.decomposition(x);

N = L/2^scale;  % center position


nB = obj.nband;

figure;
count = 1;
for iband = 1:nB
        
    for d2 = 1:2
        % Imaginary
        d1 = mod(d2,2)+1;
        w{scale}{d1}{d2}{iband}(N/2, N/2) = 1;

        obj.coeff = w;
        y1 = reconstruction(obj);

        w{scale}{d1}{d2}{iband}(N/2, N/2) = 0;
%         subplot_tight(4,6,pos(iband));
subplot_tight(4,6,count);
ShowImage(y1);
count = count +1;
%         figure;ShowImage(y1);
        
        % Real
%         d1 = d2;
%         w{scale}{d1}{d2}{iband}(N/2, N/2) = 1;
% 
%         obj.coeff = w;
%         y2 = reconstruction(obj);
%         w{scale}{d1}{d2}{iband}(N/2, N/2) = 0;
        
%         y_mag = sqrt(y1.^2 + y2.^2);
%         figure;ShowImage(y_mag);
        
    end
    
end




end

