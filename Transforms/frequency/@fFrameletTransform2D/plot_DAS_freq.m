function plot_DAS_freq( obj, scale )
%PLOT_DAS_FREQ Plot the DAS in frequency domain.
%
%Input:
%   scale:
%       Plot the DAS up to this level
%
%   Chenzhe
%   Feb, 2016
%

if scale <=4
    K = 4;      % max level of decomposition
else
    K = scale;
end
L = 8*2^K;  % size of image
% L = 256;
x = zeros(L,L);

%% Transform
obj.nlevel = scale;
w = obj.decomposition(x);

figure
colormap(jet)

for iscale = scale:scale
    N = L/2^iscale;  % center position
    nB = length(w{iscale});
    
    for iband = 1:nB
        
        w{iscale}{iband}(N/2, N/2) = 1;
        obj.coeff = w;
        yt = reconstruction(obj);
        w{iscale}{iband}(N/2, N/2) = 0;
        
        yf = fftshift(abs(fft2(yt)));
        
        surf(yf); axis tight;colorbar
        view(0, 90);%tightfig;
        hold on; pause(0.2);
        
    end
    
end



end

