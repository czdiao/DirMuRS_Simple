clear;
addpath('.\256data');
addpath('.\Utilities');
addpath('.\DFrT_Tensor');

nsiglist    = [0 5 10 20 30 50];
imlist      = {'Barbara256.png','Cman.png','House.png','Lena.png','Peppers.png'};
masklist    = {'Text1.png','Text2.png','256M50.png','256M80.png'};

in    = 1;   % 1:6  choice for noise
imask = 1;   % 1:4  choice for mask
im    = 1;   % 1:5  choice for image
%==========================================================================
nsig        = nsiglist(in);
maskname    = masklist{imask};
imname      = imlist{im};
img         = double(imread(imname));
mask        = imread(maskname);
%==========================================================================
randn('seed',0)
nimg        = img.*mask + randn(size(img))*nsig;
%==========================================================================
if  imask == 1 || imask == 2 
    tol2 = 1e-4; 
    N1   = 8; 
    N2   = 5;
elseif imask == 3 || imask == 4
    tol2 = 1e-3; 
    N1   = 5; 
    N2   = 8;
end
bound       = 1;
tol1        = 5e-3;
%==========================================================================
c           = sum(mask(:))/size(img,1)/size(img,2);
minlambda   = max(nsig - (1-c)^2*nsig/2, 1);  
sigma1      = logspace(log10(minlambda),log10(max(15,2*minlambda)),N1);
sigma2      = logspace(log10(max(2*minlambda+10,20)),log10(512),N2);
%==========================================================================
[imgout,it] = main(img,mask,nsig,sigma2, sigma1,tol1,tol2,bound);
%==========================================================================
disp(['PSNR= ' num2str(psnr(imgout,img)),' ', 'Iteration= ',num2str(it)])

figure;
subplot(131)
imshow(img,[])
title('Clean image')

subplot(132)
imshow(nimg,[])
title('Degraded image')

subplot(133)
imshow(imgout,[])
title('Recovered image')

















