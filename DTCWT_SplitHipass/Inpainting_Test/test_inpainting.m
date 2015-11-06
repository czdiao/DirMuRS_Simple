clear;

%% Set Home Path and Add to Path
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
OLD_CODE = [HOME_PATH 'old_code'];
path(pathdef);
addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));
rmpath(genpath([HOME_PATH 'Pics']));


%%
nsiglist    = [0 5 10 20 30 50];
imlist      = {'Barbara512.png','Boat.png','Hill.png','Man.png','Mandrill.png', 'fingerprint.png'};
masklist    = {'Text3.png','Text4.png','512M50.png','512M80.png'};

in    = 1;   % 1:6  choice for noise
imask = 2;   % 1:4  choice for mask
im    = 2;   % 1:5  choice for image
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
tic;
[imgout,it, img_proc] = main_DTsplit(img,mask,nsig,sigma2, sigma1,tol1,tol2,bound);
time = toc/it;
fprintf('\nAverage time for each iteration is %f\n', time);

disp(['PSNR= ' num2str(psnr(imgout,img, 255)),' ', 'Iteration= ',num2str(it)])% 
% figure;
% subplot_tight(1,3,1)
% imshow(img,[])
% title('Clean image')
% 
% subplot_tight(1,3,2)
% imshow(nimg,[])
% title('Degraded image')
% 
% subplot_tight(1,3,3)
% imshow(imgout,[])
% title('Recovered image')



% for i = 1:size(img_proc,3)
%     ShowImage(img_proc(:,:,i));
%     title(num2str(i));
%     M(i) = getframe(gcf);
% end


err_abs = zeros(size(img_proc));
for i = 1:size(img_proc, 3)
    err_abs(:,:,i) = abs(img_proc(:,:,i)-img);
%     err_abs(1,1,i) = 200;
    ShowImage(err_abs(:,:,i));
    title(num2str(i));
    colorbar;
    M(i) = getframe(gcf);
    pause(0.3)
end









