function x = isymext_d3(xExt,Num)
%% Inverse of symext
% Cut the middle part of a symmetric extension image
%
% 

if Num == 0 
    x = xExt;
    return;
end

[ky,kx,kz] = size(xExt);
ky0        = ky - 2*Num;
kx0        = kx - 2*Num;
kz0        = kz - 2*Num;

x          = xExt(Num+1:Num+ky0,Num+1:Num+kx0,Num+1:Num+kz0);

end