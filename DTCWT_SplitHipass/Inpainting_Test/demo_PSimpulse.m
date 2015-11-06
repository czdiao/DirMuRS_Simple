clear

% addpath('.\Utilities');
% addpath('.\DFrT_Tensor');
% addpath('.\impulsedata')

% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% OLD_CODE = [HOME_PATH 'old_code'];
% addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));



nsiglist1 = [0 10 15];

noiselevel2  = 30; % noise ratio for Salt-and-Pepper noise

imagelist = {'1.png','2.png','5.png','6.png','3.png','7.png'};


tic

for i2 = 1;  % Gaussian
for k =  1;  % image

nsig         = nsiglist1(i2);
img          = double(imread(imagelist{k}));

%==========================================================================
nimg1        = img + randn(size(img))*nsig;
imgMasked    = impulsenoise(nimg1,noiselevel2/100,0);
%==========================================================================

[y nois_ma2] = amf(imgMasked,39,0,0);   
r               = abs(y - imgMasked);
[~, I]          = sort(r(:));
mask            = zeros(size(r));
mask(I(1:floor((1-noiselevel2/100)*numel(r)))) = 1;     

numimg = length(mask(:));

bound        = 1;
tol1         = 1e-3;
tol2         = noiselevel2/100 * 0.001;
iteration    = 500;
nLvl         = 4;            % decomposition level;
lpy          = sqrt(sum(imgMasked(:).^2));

if bound == 1
    L         = length(imgMasked); % length of the original image.
    imgMasked = symextend(imgMasked,2^(nLvl-1));
    mask      = symextend(mask,2^(nLvl-1));
    ind = 2^(nLvl -1)+1:2^(nLvl -1)+L;    
end

maskt      = zeros(size(mask));
params     = cwavelet(imgMasked,nLvl);
x2         = zeros(size(imgMasked));

i          = 1;
nlambda    = 6;
p          = noiselevel2/100;

minlambda  = max(nsig*(1-p^2/2),1);
maxlambda  = max(nsig,100*p);
lambdalist = linspace(maxlambda,minlambda,nlambda);

lambda     = lambdalist(i);

nn         = 1;

for it = 1:iteration

y     = x2.*~mask + imgMasked.*mask;
x1    = x2;
%==================================================
fout      = tensor_frdec2d(y,params);
coefs     = fout.coefs;
load nrm
coefs     = tensor_nrmCoefs(coefs,nrm,1);
%--------------------------------------------------------------------
thr_coefs = thr_bishrink(coefs,lambda);
%--------------------------------------------------------------------
thr_coefs = tensor_nrmCoefs(thr_coefs,nrm,-1);
foutNew   = fout;
foutNew.coefs = thr_coefs;
%--------------------------------------------------------------------
rec_img   = tensor_frrec2d(foutNew,params);
x2        = abs(rec_img);      
%=====================================================================
temperror = (x1 - x2);
ntol = sqrt(sum((temperror(:)).^2))/lpy;

%--------------------------------------------------------------------
if    ntol <tol1 
   i = i+1;
   if (i > (nlambda))
       break
   end  
   lambda = lambdalist(i);
end


if bound == 1
    x3 = x2(ind,ind);
else
    x3 = x2;
end

%disp([ 'Iter: ' num2str(it), ' ', 'PSNR: ', num2str(psnr(img,x3))]);

end

if bound == 1
imgout = x2(ind,ind);
end

disp(psnr(imgout,img, 255));
end
end
toc

subplot(121)
imshow(imgMasked,[])
subplot(122)
imshow(imgout,[])
