function img = ifft2_n(fimg,opt)
%% normalized and centered ifft2
%

%%
if nargin == 1
    opt = 1;
end
if opt == 1
    [m,n] = size(fimg);
    img = ifft2(ifftshift(fimg))*sqrt(m*n);
else
    [m,n] = size(fimg);
    img = AdjfrFT(fimg.',1/n)/sqrt(n);
    img = AdjfrFT(img.',1/m)/sqrt(m);
end
end