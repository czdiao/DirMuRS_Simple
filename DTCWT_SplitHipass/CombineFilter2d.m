function [ W_new ] = CombineFilter2d( W1, u1, W2, u2, dim  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



if dim == 1
    tmp1 = d2tconv_fir(W1, u1.filter, u1.start_pt, 1, 0);
    tmp2 = d2tconv_fir(W2, u2.filter, u2.start_pt, 1, 0);
elseif dim ==2
    tmp1 = d2tconv_fir(W1, 1, 0, u1.filter, u1.start_pt);
    tmp2 = d2tconv_fir(W2, 1, 0, u2.filter, u2.start_pt);
end

W_new = tmp1+tmp2;


end

