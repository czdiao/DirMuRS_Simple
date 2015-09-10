function [ y ] = denoise_BiShrink_new(x,J, sigmaN, FS_filter1d, fb1d, nor, Transform, varargin)
%DENOISE_BISHRINK_NEW Denoising using Bivariate Shrinkage + DT based transforms.
% Local Adaptive Image Denoising Algorithm
%
% Examples:
%   1)  For DT-CWT
%       y = denoise_BiShrink_new(x,J, sigmaN, FS_filter1d, fb1d, nor, 'DT')
%   2)  For DT-CWT Split Highpass
%       y = denoise_BiShrink_new(x,J, sigmaN, FS_filter1d, fb1d, nor, 'DT_SplitHigh', u_hi)
%   3)  For DT-CWT Split both Highpass and lowpass
%       y = denoise_BiShrink_new(x,J, sigmaN, FS_filter1d, fb1d, nor, 'DT_SplitHighLow', u_hi, u_low)
%
%
% INPUT :
%        x:
%           a noisy image
%        J: 
%           level of decomposition
%        sigmaN:
%           noise level.
%        FS_filter1d:
%           First stage filter banks.
%        fb1d:
%           filter banks for both trees.
%        nor:
%           norm of the multi-level filters.
%        Transform:
%           'DT', 'DT_SplitHigh', 'DT_SplitHighLow'
%
% Optional Input:
%        varargin{1}:
%           u_hi(2), 2 filters to split the highpass filters.
%        varargin{2}:
%           u_low(2), 2 filters to split the lowpass filters.
%
% OUTPUT :
%        y - the corresponding denoised image
%
%   Chenzhe Diao
%   Sept, 2015



% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);


switch Transform
    case('DT')
        W = DualTree2d_new(x, J, FS_filter1d, fb1d);
    case('DT_SplitHigh')
        u_hi = varargin{1};
        W = DualTree2d_SplitHigh(x, J, FS_filter1d, fb1d, u_hi);
    case('DT_SplitHighLow')
        u_hi = varargin{1};
        u_low = varargin{2};
        W = DualTree2d_SplitHighLow(x, J, FS_filter1d, fb1d, u_hi, u_low);
    otherwise
        error('Unknown Transform type!');
end


W = normcoef_dt(W,J,nor);
W = thr_bishrink_dt(W, sigmaN);
W = unnormcoef_dt(W,J,nor);

switch Transform
    case('DT')
        y = iDualTree2d_new(W, J, FS_filter1d, fb1d);
    case('DT_SplitHigh')
        y = iDualTree2d_SplitHigh(W, J, FS_filter1d, fb1d, u_hi);
    case('DT_SplitHighLow')
        y = iDualTree2d_SplitHighLow(W, J, FS_filter1d, fb1d, u_hi, u_low);
    otherwise
        error('Unknown Transform type!');
end


% Extract the image
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);




end

