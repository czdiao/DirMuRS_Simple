function fimg = fft3_n(img,opt)
%% normalized fft2 and center zero frequency
%


%%
if nargin == 1
    opt = 1;
end
if opt == 1
    [m,n,p] = size(img);
    fimg = fftshift(fftn(img))/sqrt(m*n*p);
else
   [m,n] = size(img);
   fimg = frFT(img,1/m)/sqrt(m);
   fimg = frFT(fimg.',1/n)/sqrt(n);
   fimg = fimg.';
end
end