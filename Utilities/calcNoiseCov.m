function [Cr_w,Ci_w] = calcNoiseCov(nf,dim,params,denoise_params)
% 
% This function calculates the noise covariance matrix C_w of tensor product 
% complex tight framelets (TP-CTF). This code uses UNDECIMATED TP-CTF 
% transform to calculate the noise covariance matrix for the DECIMATED 
% TP-CTF transform. C_w is calculated by filter banks.
% 
% Input:
%     nf : noise standard deviation
%     dim: the size of image after extension
%     params: parameters for TP-CTF transform
%     denoise_params: paramters for setting denoising
% Output:
%     Cr_w, Ci_w: noise covariance matrix for real and imaginary parts
%%
PS      = ones(dim);
delta   = fftshift(real(ifft2(sqrt(PS))));
delta   = nf*delta/sqrt(mean2(delta.^2));
delta   = max(delta(:));

nscales = params.nLvl;
block   = denoise_params.block;

% decompose zeros
foutZ = tensor_frdec2d(zeros(dim),params);
coefZ = foutZ.coefs;

% bandpass covariances
for j = 1:nscales-1
  pos = length(coefZ{j}{1})/2;
  for k = 1:length(coefZ{j})
    cont = 1;
    for m = pos-2^j*floor(block(1)/2):2^j:pos+2^j*floor(block(1)/2)
       for n = pos-2^j*floor(block(2)/2):2^j:pos+2^j*floor(block(2)/2)
          fout.coefs = coefZ;
          fout.coefs{j}{k}(m,n) = delta;
          % normalize undecimated coeff to decimated coeff
          y = 2^j*tensor_frrec2d(fout,params);          
          %figure, imagesc(real(y)),colormap(gray),axis image;
          zzpr(cont,:) = real(y(:)');
          zzpi(cont,:) = imag(y(:)');
          cont = cont + 1;
        end
    end
    Cr_w{j}{k} = zzpr*zzpr'/size(zzpr,2);
    Ci_w{j}{k} = zzpi*zzpi'/size(zzpi,2);
  end
end

end