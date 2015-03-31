function fimg0 = ifext(fimg,kx_l,kx_r,ky_l,ky_r,opt)
%% Inverse of fext
%
%  INPUT
%     fimg: image was extended with parameters kx_l, kx_r, ...
%     kx_l,....: left, right, up, down size
%     opt : opt = 1; sum up the extended part
%           opt = 0; only keep the middle part
% SEE ALSO
%   fext

if nargin == 5
    opt = 1;
end
[ky,kx] = size(fimg);
kx0 = kx-kx_l-kx_r;
ky0 = ky-ky_l-ky_r;
 
fimg0 = zeros(ky0,kx0);

% center
fimg0 = fimg(ky_l+1:ky_l+ky0,kx_l+1:kx_l+kx0);  

% left up 
fimg0(ky0-ky_l+1:ky0,kx0-kx_l+1:kx0) = fimg0(ky0-ky_l+1:ky0,kx0-kx_l+1:kx0)+fimg(1:ky_l,1:kx_l)*opt; 

% left middle 
fimg0(1:ky0,kx0-kx_l+1:kx0) = fimg0(1:ky0,kx0-kx_l+1:kx0) + fimg(ky_l+1:ky_l+ky0,1:kx_l)*opt;

% left bottom
fimg0(1:ky_r,kx0-kx_l+1:kx0) =  fimg0(1:ky_r,kx0-kx_l+1:kx0)+ fimg(ky-ky_r+1:ky,1:kx_l)*opt; 

% middle up
fimg0(ky0-ky_l+1:ky0,1:kx0) = fimg0(ky0-ky_l+1:ky0,1:kx0) + fimg(1:ky_l,kx_l+1:kx_l+kx0)*opt;

% middle bottom
fimg0(1:ky_r,1:kx0) = fimg0(1:ky_r,1:kx0) + fimg(ky-ky_r+1:ky,kx_l+1:kx_l+kx0)*opt; 

% right up
fimg0(ky0-ky_l+1:ky0,1:kx_r) = fimg0(ky0-ky_l+1:ky0,1:kx_r)+fimg(1:ky_l,kx-kx_r+1:kx)*opt; 

% right middle
fimg0(1:ky0,1:kx_r) = fimg0(1:ky0,1:kx_r) + fimg(ky_l+1:ky-ky_r,kx-kx_r+1:kx)*opt; 

% right bottom
fimg0(1:ky_r,1:kx_r) = fimg0(1:ky_r,1:kx_r)+fimg(ky-ky_r+1:ky,kx-kx_r+1:kx)*opt;

end