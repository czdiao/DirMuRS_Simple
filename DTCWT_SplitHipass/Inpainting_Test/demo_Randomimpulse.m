clear;

% addpath('.\Utilities');
% addpath('.\DFrT_Tensor');
% addpath('.\impulsedata')

% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% OLD_CODE = [HOME_PATH 'old_code'];
% addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));

% Set Filters and compute norms.
[FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
% To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];
% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];

nLvl = 5;
nor = CalFilterNormDT2D(FS_filter1d, fb1d, nLvl, 'DT_SplitHighLow', u_hi, u_low);


nsiglist1 = [10 20 30];   % Gaussian
nsiglist2 = [5 10 20];    % Impluse
imagelist = {'1.png','2.png','5.png','6.png','3.png','7.png'};

tic
for i2 = 1;  % guassian
for j =  1;  % impulse
for k =  2;  % image

nsig         = nsiglist1(i2);
noiselevel2  = nsiglist2(j);
img          = double(imread(imagelist{k}));
name         = ['n',num2str(i2),num2str(j),num2str(k)];

%=============================================================
nimg1        = img + randn(size(img))*nsig;
imgMasked    = impulsenoise(nimg1,noiselevel2/100,1);
%=============================================================

%==========================================================================
bound        = 1;
tol1         = 1e-3;
tol2         = noiselevel2/100 * 0.2;
iteration    = 500;
nLvl         = 4;            % decomposition level;
lpy          = sqrt(sum(imgMasked(:).^2));

mask   = ones(size(img));

if bound == 1
    L         = length(imgMasked); % length of the original image.
    imgMasked = symext(imgMasked,2^(nLvl-1));
    mask      = symext(mask,2^(nLvl-1));
    ind = 2^(nLvl -1)+1:2^(nLvl -1)+L;    
end
numimg = sum(mask(:));

maskt      = zeros(size(mask));

% params     = cwavelet(imgMasked,nLvl);

x2         = zeros(size(imgMasked));

i          = 1;
nlambda    = 5;
p          = noiselevel2/100;

minlambda  = nsig*(1-p^2/2);
maxlambda  = max(nsig,noiselevel2);
lambdalist = linspace(maxlambda,minlambda,nlambda);

lambda     = lambdalist(i);

nn         = 1;

for it = 1:iteration

y     = x2.*~mask + imgMasked.*mask;
x1    = x2;
%==================================================
% fout      = tensor_frdec2d(y,params);
% coefs     = fout.coefs;
% coefs     = tensor_nrmCoefs(coefs,nrm,1);
W = DualTree2d_SplitHighLow(imgMasked, nLvl, FS_filter1d, fb1d, u_hi, u_low);
W = normcoef_dt(W, nLvl, nor);
%--------------------------------------------------------------------
thr_coefs = thr_bishrink_dt(W,lambda);
%--------------------------------------------------------------------
% thr_coefs = tensor_nrmCoefs(thr_coefs,nrm,-1);
thr_coefs = unnormcoef_dt(thr_coefs, nLvl, nor);
% foutNew   = fout;
% foutNew.coefs = thr_coefs;
%--------------------------------------------------------------------
% rec_img   = tensor_frrec2d(foutNew,params);
rec_img = iDualTree2d_SplitHighLow(thr_coefs, nLvl, FS_filter1d, fb1d, u_hi, u_low);

x2        = abs(rec_img);      
%=====================================================================
temperror = (x1 - x2);
ntol = sqrt(sum((temperror(:)).^2))/lpy;

%--------------------------------------------------------------------
if    ntol <tol1
 
   i = i+1;
   if i > nlambda
       break
   end
   %=========================================================
   %update mask
   %disp(['mask update'])   
   r               = abs(imgMasked - x2);
   [~, I]          = sort(r(:));
   mask            = zeros(size(r));
   mask(I(1:floor((1-noiselevel2/100)*numel(r)))) = 1;      
   %=========================================================
   nn = sum(abs(maskt(:)-mask(:)))/numimg;
   
   if (nn < tol2) 
       i = nlambda;
   end  
   
   lambda = lambdalist(i);
   maskt = mask;   
   
   
   
   
   
end

if bound == 1
    x3 = x2(ind,ind);
else
    x3 = x2;
end

%disp([ 'Iter: ' num2str(it), ' ', 'PSNR: ', num2str(psnr(img,x3)),' maskerror ',num2str(nn)]);

end

if bound == 1
imgout = x2(ind,ind);
imgMasked = imgMasked(ind,ind);
end


disp([imagelist{k}, ' PSNR= ', num2str(psnr(imgout,img, 255)),...
      ' Gaussian= ',num2str(nsig),...
      ' Impulse=  ',num2str(noiselevel2)])

end
end
end

toc


subplot(121)
imshow(imgMasked,[])
subplot(122)
imshow(imgout,[])



