function plot_DAS_freq( obj, scale )
%PLOT_DAS_FREQ Plot the DAS in frequency domain.
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

figure
colormap(jet)

I = sqrt(-1);
for iband = 1:nB
        
    for d2 = 1:2
        % Imaginary
        d1 = mod(d2,2)+1;
        w{scale}{d1}{d2}{iband}(N/2, N/2) = 1;
        obj.coeff = w;
        y1 = reconstruction(obj);
        w{scale}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        % Real
        d1 = d2;
        w{scale}{d1}{d2}{iband}(N/2, N/2) = 1;
        obj.coeff = w;
        y2 = reconstruction(obj);
        w{scale}{d1}{d2}{iband}(N/2, N/2) = 0;
        
        yt = y2 + I*y1;
        yf = fftshift(abs(fft2(yt)));
        
        surf(yf); axis tight;colorbar
        view(0, 90);%tightfig;
        hold on; pause(0.5);
        
        yt = y2 - I*y1;
        yf = fftshift(abs(fft2(yt)));
        
        surf(yf); axis tight;colorbar
        view(0, 90);%tightfig;
        hold on; pause(0.5);
        
    end
    
end





end

