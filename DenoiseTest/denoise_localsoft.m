function y = denoise_localsoft( x, Nsig, wavetrans, x_true )
%DENOISE_LOCALSOFT Denoising an image using local soft
%Input:
%   x:
%       Noisy image
%   Nsig:
%       Noise level, variance sigma
%   wavetrans:
%       Of some wavelet transform class. Should be of some subclass of
%       WaveletData2D. Supporting the WaveletData2D interface.
%   x_true: (optional)
%       latent true image, for calculation of the true latent local sigma.
%       This is for testing purpose only.
%
%
%   Chenzhe
%   Jan, 2016
%

if nargin == 4  % if x_true is supplied, calculate true latent sigma
    WT_true = wavetrans;
    L = length(x_true); % length of the original image.
    buffer_size = L/2;
    x_true = symext(x_true,buffer_size);
    
    WT_true.coeff = WT_true.decomposition(x_true);
    WT_true.coeff = WT_true.normcoeff;
    latent_sigma_true = WT_true.calSigma;
end

WT = wavetrans;
% symmetric extension, to reduce boundary effects
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);

WT.coeff = WT.decomposition(x);
WT.coeff = WT.normcoeff;

% choose to use true sigma or estimated sigma
WT.coeff = WT.LocalSoft(latent_sigma_true, Nsig);
% Sig_est = WT.latentSigma(Nsig, 'local_soft');
% WT.coeff = WT.LocalSoft(Sig_est,Nsig);

WT.coeff = WT.unnormcoeff;
y = WT.reconstruction;

% Extract the image
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);

end

