function [ W_new ] = fPostCombine( W1, u1, W2, u2, dim )
%FPOSTCOMBINE Summary of this function goes here
%   Detailed explanation goes here

if max(abs(W1(:)))<=eps
    tmp1 = W1;
else
    tmp1 = fconv(u1, W1, dim);
end

if max(abs(W2(:)))<=eps
    tmp2 = W2;
else
    tmp2 = fconv(u2, W2, dim);
end


W_new = tmp1+tmp2;




end

