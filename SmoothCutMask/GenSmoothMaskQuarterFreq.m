function [ mask ] = GenSmoothMaskQuarterFreq( logicmask, r )
%GENSMOOTHMASKQUARTERFREQ Generate Smooth Mask in Frequency Domain. This
%function could be used if we only need the info in a quarter freq domain,
%and the other 3 quarters are symmetric. 
%
%Input:
%   logicmask:
%       The given mask is the information in the 2nd quadrant.
%   r:
%       See GenSmoothMask()
%
%   Chenzhe
%   Feb, 2016
%

mask = GenSmoothMask(logicmask, r);

mask1 = mask(:, end:(-1):1);
mask = [mask, mask1];
mask1 = mask(end:(-1):1, :);
mask = [mask; mask1];


end

