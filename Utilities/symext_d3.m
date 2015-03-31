function [xExt] = symext_d3(x,Nnum)
%% Symmetric extension
%
%
if Nnum == 0
    xExt = x;
    return;
end

[ky0,kx0,kz0]             = size(x);
ky                        = ky0+2*Nnum;
xExt0                     = zeros(ky,kx0,kz0);

xExt0(Nnum+1:Nnum+ky0,:,:)= x;
xExt0(1:Nnum,        :,:) = x(Nnum:-1:1,        :,:);
xExt0(end-Nnum+1:end,:,:) = x(end:-1:end-Nnum+1,:,:);

kx                        = kx0+2*Nnum;
xExt1                     = zeros(ky,kx,kz0);
xExt1(:,Nnum+1:Nnum+kx0,:)= xExt0;
xExt1(:,1:Nnum,        :) = xExt0(:,Nnum:-1:1,        :);
xExt1(:,end-Nnum+1:end,:) = xExt0(:,end:-1:end-Nnum+1,:);

clear xExt0;

kz                        = kz0+2*Nnum;
xExt                      = zeros(ky,kx,kz);
xExt(:,:,Nnum+1:Nnum+kz0) = xExt1;
xExt(:,:,1:Nnum)          = xExt1(:,:,Nnum:-1:1);
xExt(:,:,end-Nnum+1:end)  = xExt1(:,:,end:-1:end-Nnum+1);

clear xExt1;
end