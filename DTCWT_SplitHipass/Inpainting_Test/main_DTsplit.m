function [x2, it, rec_proc] = main_DTsplit(img,mask,nsig,sigma1,sigma2,tol1,tol2,bound)


%load nrm
randn('seed',0)

sigmalist = [sigma2 sigma1];

iteration  = 500;
nLvl_DT       = 4;            % decomposition level;
nLvl_Split    = 5;
nLvl = nLvl_DT;

% Add filters
[FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
% To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];
% To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];

nor_DT = CalFilterNormDT2D(FS_filter1d, fb1d, nLvl_DT, 'DT');
nor_DTsplit = CalFilterNormDT2D(FS_filter1d, fb1d, nLvl_Split, 'DT_SplitHighLow', u_hi, u_low);

transform_func = @(x) DualTree2d(x, nLvl, FS_filter1d, fb1d);
itransform_func = @(W) iDualTree2d(W, nLvl, FS_filter1d, fb1d);
nor = nor_DT;

% transform_func = @(x) DualTree2d_SplitHighLow(x, nLvl, FS_filter1d, fb1d, u_hi, u_low);
% itransform_func = @(W) iDualTree2d_SplitHighLow(W, nLvl, FS_filter1d, fb1d, u_hi, u_low);
% nor = nor_DTsplit;

imgMasked  = img.*mask + randn(size(img))*nsig;

py = imgMasked.*mask;
lpy = sqrt(sum(py(:).^2));

rec_proc(:,:,1) = imgMasked;


if bound == 1;
    
    L         = length(imgMasked); % length of the original image.
    len_ext = 2^nLvl_DT;  %2^(nLvl-1);
%     len_ext = L/2;
    imgMasked = symext(imgMasked,len_ext);
    mask      = symext(mask,len_ext);
    ind = (len_ext+1):(len_ext+L);
    
end

% py = imgMasked.*mask;
% lpy = sqrt(sum(py(:).^2));

x2         = zeros(size(imgMasked));
N2         = length(sigma2);
i          = length(sigmalist);
sigma      = sigmalist(end);

flag = 0;
for it = 1:iteration
    
    y     = x2.*~mask+ imgMasked.*mask;
    
    x1    = x2;
    %==================================================
    
%     coefs = DualTree2d_SplitHighLow(y, nLvl, FS_filter1d, fb1d, u_hi, u_low);
    coefs = transform_func(y);
    
    coefs = normcoef_dt(coefs,nLvl, nor);
    
    %--------------------------------------------------------------------
    thr_coefs = thr_bishrink_dt(coefs,sigma);
    %--------------------------------------------------------------------
    thr_coefs = unnormcoef_dt(thr_coefs, nLvl, nor);
    %--------------------------------------------------------------------
%     rec_img = iDualTree2d_SplitHighLow(thr_coefs, nLvl, FS_filter1d, fb1d, u_hi, u_low);
    rec_img = itransform_func(thr_coefs);
    x2        = abs(rec_img);
    %=====================================================================
    temperror = (x1 - x2).*(~mask);
    ntol = sqrt(sum((temperror(:)).^2))/lpy;
    %--------------------------------------------------------------------
    
    if    ntol <tol1 && i > N2;
        i = i-1;
        sigma = sigmalist(i);
    end
    
    if i == N2 && flag==0
        flag = 1;
        nLvl = nLvl_Split;
        transform_func = @(x) DualTree2d_SplitHighLow(x, nLvl, FS_filter1d, fb1d, u_hi, u_low);
        itransform_func = @(W) iDualTree2d_SplitHighLow(W, nLvl, FS_filter1d, fb1d, u_hi, u_low);
        nor = nor_DTsplit;
    end
    
    if   ntol <tol2 && i < N2+1;
        i = i-1;
        if i == 0
            break
        end
        sigma = sigmalist(i);
    end
    
    if bound == 1
        x3 = x2(ind,ind);
    else
        x3 = x2;
    end
    
    disp([ 'Iter: ' num2str(it), ' ',...
        'PSNR: ', num2str(psnr(img,x3, 255)),' ',...
        'Sigma: ', num2str(sigma),' '...
        'ntol: ', num2str(ntol)]);
    rec_proc(:,:,it+1) = x3.*(~mask(ind,ind)) + img.*mask(ind,ind);

    
end

if bound == 1
    x2 = x2(ind,ind);
end

if nsig == 0
    mask = mask(ind,ind);
    x2 = x2.*(~mask) + img.*mask;
end

end






