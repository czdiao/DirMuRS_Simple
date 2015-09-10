function [ y ] = denoise_BiShrink_freq(x,J, sigmaN, FS_ffilter1d, ffilter1d, nor, Transform)
%DENOISE_BISHRINK_FREQ Summary of this function goes here
%   Detailed explanation goes here

% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);

switch Transform
    case('DT')
        W = fDualTree2d(x, J, FS_ffilter1d, ffilter1d);
    case('DT_SplitHigh')
        W = fDualTree2d_SplitHigh(x, J, FS_ffilter1d, ffilter1d);
    case('DT_SplitHighLow')
        W = fDualTree2d_SplitHighLow(x, J, FS_ffilter1d, ffilter1d);
end


W = normcoef_dt(W,J,nor);
W = thr_bishrink_dt(W, sigmaN);
W = unnormcoef_dt(W,J,nor);

switch Transform
    case('DT')
        y = ifDualTree2d(W, J, FS_ffilter1d, ffilter1d);
    case('DT_SplitHigh')
        y = ifDualTree2d_SplitHigh(W, J, FS_ffilter1d, ffilter1d);
    case('DT_SplitHighLow')
        y = ifDualTree2d_SplitHighLow(W, J, FS_ffilter1d, ffilter1d);
end

% Extract the image
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);


end

