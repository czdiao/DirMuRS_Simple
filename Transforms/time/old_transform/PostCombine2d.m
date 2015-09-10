function [ W_new ] = PostCombine2d( W1, u1, W2, u2, dim  )
%PostCombine2d
%   Combine the splitted filter (with u1, u2) by post-possessing the
%       wavelet coefficients. Inverse of PostSplit2d() function.
%   
%   See the documentation of PostSplit2d for argument description.



if dim == 1
    tmp1 = d2tconv_fir(W1, u1.filter, u1.start_pt, 1, 0);
    tmp2 = d2tconv_fir(W2, u2.filter, u2.start_pt, 1, 0);
elseif dim ==2
    tmp1 = d2tconv_fir(W1, 1, 0, u1.filter, u1.start_pt);
    tmp2 = d2tconv_fir(W2, 1, 0, u2.filter, u2.start_pt);
else
    error('Dimension not correct!');
end

W_new = tmp1+tmp2;


end

