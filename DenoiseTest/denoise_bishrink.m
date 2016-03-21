function y = denoise_bishrink( x, Nsig, wavetrans )
%DENOISE_BISHRINK Denoising an image using Bivariate Shrinkage
%Input:
%   x:
%       Noisy image
%   Nsig:
%       Noise level, variance sigma
%   wavetrans:
%       Of some wavelet transform class. Should be of some subclass of
%       WaveletData2D. Supporting the WaveletData2D interface.
%
%
%   Chenzhe
%   Jan, 2016
%


WT = wavetrans;
% symmetric extension, to reduce boundary effects
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);

WT.coeff = WT.decomposition(x);
WT.coeff = WT.normcoeff;

% choose to use true sigma or estimated sigma
Sig_est = WT.latentSigma(Nsig, 'local_soft');
WT.coeff = WT.BiShrink(Sig_est, Nsig);

WT.coeff = WT.unnormcoeff;
y = WT.reconstruction;

% Extract the image
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);








end

