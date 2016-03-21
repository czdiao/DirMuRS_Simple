function [ mask ] = GenSmoothMaskHalfFreq( logicmask, r )
%GENSMOOTHMASKHALFFREQ Generate Smooth Mask in Frequency Domain. This
%function could be used if we only need the info in a half freq domain,
%and the other quarter is symmetric to it.
%
%Input:
%   logicmask:
%       The given mask is the information in the upper half plane. The
%       lower half plane is symmetric to the upper half. So if we use this
%       mask to cut the frequency domain, the ifft2 will still give real
%       image in time domain.
%   r:
%       See GenSmoothMask()
%
%   Chenzhe
%   Feb, 2016
%

mask = GenSmoothMask(logicmask, r);
mask1 = mask(:, end:(-1):1);
mask1 = mask1(end:(-1):1, :);
mask = [mask; mask1];


end

