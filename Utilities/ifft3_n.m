function img = ifft3_n(fimg,opt)
%% normalized and centered ifft2
%

%%
if nargin == 1
    opt = 1;
end
if opt == 1
    [m,n,p] = size(fimg);
    img = ifftn(ifftshift(fimg))*sqrt(m*n*p);
else
    [m,n] = size(fimg);
    img = AdjfrFT(fimg.',1/n)/sqrt(n);
    img = AdjfrFT(img.',1/m)/sqrt(m);
end
end