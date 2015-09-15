function y = denoise_BiShrink(x,J, sigmaN, FS_filter2d, filter2d, nor, split_low, t1, t2, t3)
% Local Adaptive Image Denoising Algorithm
% Usage :
%        y = denoising_dtdwt(x)
% INPUT :
%        x - a noisy image
% OUTPUT :
%        y - the corresponding denoised image



% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);


% load nor_dualtree_noise    % run ComputeNorm_noise to generate this mat file.
% load('nor_selesnick_origDT.mat');
% load('nor_selesnick_OrigHaar.mat');
% load('nor_selesnick_Q1Haar.mat');
% load('nor_selesnick_splitlow.mat');


if split_low
    W = DualTree2d_SplitLow(x, J, FS_filter2d, filter2d, t1, t2, t3);
else
    W = DualTree2d(x, J, FS_filter2d, filter2d);
end

W = normcoef_dt(W,J,nor);
W = thr_bishrink_dt(W, sigmaN);
W = unnormcoef_dt(W,J,nor);

if split_low
    y = iDualTree2d_SplitLow(W, J, FS_filter2d, filter2d, t1, t2, t3);
else
    y = iDualTree2d(W, J, FS_filter2d, filter2d);
end

% Extract the image
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);


end











