function zfimg = fext(fimg0,kx_l,kx_r,ky_l,ky_r)
%% Periodic Extension of Image
% INPUT
%   fimg0: input image
%   kx_l : left extension size
%   kx_r : right extension size
%   ky_l : top extension size
%   ky_r : bottom extension size
%
%% Example
% img = pascal(5);
% zimg = fext(img,1,2,3,4)

 [ky0,kx0] = size(fimg0);
 kx = kx0+kx_l+kx_r;
 ky = ky0+ky_l+ky_r;
 if max(kx_l,kx_r) > kx0 || max(ky_l,ky_r) >ky0
     error('extension size too large!');
 end
 
 zfimg = zeros(ky,kx);

% center
zfimg(ky_l+1:ky_l+ky0,kx_l+1:kx_l+kx0) = fimg0;  

% left up 
zfimg(1:ky_l,1:kx_l) = fimg0(ky0-ky_l+1:ky0,kx0-kx_l+1:kx0); 

% left middle 
zfimg(ky_l+1:ky_l+ky0,1:kx_l) = fimg0(1:ky0,kx0-kx_l+1:kx0);

% left bottom
zfimg(ky-ky_r+1:ky,1:kx_l) = fimg0(1:ky_r,kx0-kx_l+1:kx0); 

% middle up
zfimg(1:ky_l,kx_l+1:kx_l+kx0) = fimg0(ky0-ky_l+1:ky0,1:kx0);

% middle bottom
zfimg(ky-ky_r+1:ky,kx_l+1:kx_l+kx0) = fimg0(1:ky_r,1:kx0); 

% right up
zfimg(1:ky_l,kx-kx_r+1:kx) = fimg0(ky0-ky_l+1:ky0,1:kx_r); 

% right middle
zfimg(ky_l+1:ky-ky_r,kx-kx_r+1:kx) = fimg0(1:ky0,1:kx_r); 

% right bottom
zfimg(ky-ky_r+1:ky,kx-kx_r+1:kx) = fimg0(1:ky_r,1:kx_r);

end