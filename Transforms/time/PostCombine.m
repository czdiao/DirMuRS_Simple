function [ W_new ] = PostCombine( W1, u1, W2, u2, dim  )
%PostCombine
%   Combine the splitted filter (with u1, u2) by post-possessing the
%       wavelet coefficients. Inverse of PostSplit2d() function.
%   
%   See the documentation of PostSplit for argument description.


if max(abs(W1(:)))>eps
    tmp1 = tconv(u1, W1, dim);
else
%     tmp1 = zeros(size(W1));
    tmp1 = W1;
end

if max(abs(W2(:)))>eps
    tmp2 = tconv(u2, W2, dim);
else
%     tmp2 = zeros(size(W2));
    tmp2 = W2;
end

W_new = tmp1+tmp2;


end

