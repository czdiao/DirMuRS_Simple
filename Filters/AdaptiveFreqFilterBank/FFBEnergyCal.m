function [ ffb2d_new ] = FFBEnergyCal( ffb2d, img )
%FFBENERGYCAL Calculate the energy distribution of the frequency-based
%filters in the image.
%
%
%   Chenzhe
%   Mar, 2016
%

ffb2d_new = ffb2d;
fdata = log(abs(fft2(img)));
% fdata = fft2(img);

len = length(ffb2d);    % number of filters


% total_E = 0;
for i = 1:len
    tmp = ffb2d(i).fconv(fdata);
    E = sqrt(sum(sum(abs(tmp).^2)));
    ffb2d_new(i).EnergyPortion = E;  % do we need to divide the norm of the filter?
%     total_E = total_E + E;
end



end

