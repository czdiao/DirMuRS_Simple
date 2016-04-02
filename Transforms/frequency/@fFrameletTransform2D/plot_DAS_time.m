function plot_DAS_time( obj, scale )
%PLOT_DAS_TIME Plot the DAS in time domain.
%
%Input:
%   scale:
%       Plot the DAS at this level
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
x = zeros(L,L);

%% Transform
obj.nlevel = scale;
w = obj.decomposition(x);


% N = L/2^scale;  % center position
nB = length(w{scale});

for iband = 1:nB
    
    [M, N] = size(w{scale}{iband}); % center position
    w{scale}{iband}(M/2, N/2) = 1;
    obj.coeff = w;
    yt = reconstruction(obj);
    w{scale}{iband}(M/2, N/2) = 0;
    
    % We only plot the real parts
    yr = real(yt);
%     yi = imag(yt);
    
    figure;
    ShowImage(yr);
    
end



end

