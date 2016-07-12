function  y  = denoise_GSM( x, Nsig, wavetrans, blocksize )
%DENOISE_GSM Denoise using Gaussian Scale Mixture Model.
%
%   Currently only works for TPCTF transform.
%   The GSM algorithm is performed on real/imag part of each band
%   separately. No information about parents is used.
%
%   Chenzhe
%   Jun, 2016
%
%


WT = wavetrans;


% load noise covariance matrix Cwr, Cwi, stored for 5 levels
% if blocksize==3
%     load Cw_CTF6_3x3.mat
% elseif blocksize==5
%     load Cw_CTF6_5x5.mat
% else
%     error('Unknown blocksize, call [Cwr, Cwi] = dtwavelet.CalCovMatrix(N, blocksize) to generate !');
% end
% load Cw_CTF6_5x5_undec.mat
[ Cwr, Cwi ] = WT.CalCovMatrix( 512+32, blocksize);


% symmetric extension, to reduce boundary effects
L = length(x); % length of the original image.
buffer_size = 16;  % L/2;
x = symext(x,buffer_size);



WT.coeff = WT.decomposition(x);
WT.coeff = WT.GSMDenoise(blocksize, Cwr, Cwi, Nsig );

y = WT.reconstruction;

% Extract the image
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);



end

