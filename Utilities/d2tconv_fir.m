function [ y ] = d2tconv_fir( v,u_r,stp_r,u_c,stp_c )
%D2TCONV_FIR Convolution using build-in upfirdown implementation for speed
%
% INPUT
%   v      : 2D signal
%   u_r    : input row convolution filter u_r = [u_r(stp_r), u_r(stp_r+1),...]
%   u_c    : input column convolution filter u_c = [u_c(stp_c), u_c(stp_c+1),...]
%            choice : default periodic extension
% OUTPUT:
%   y: v circular convolute with u_r tensor of u_c
%      i.e., y = v*[u_c(x)u_r], (x) means tensor

%   Note:
%       We require the signal v to be longer than the filter.
%       [M, N] = size(v), then N>=length(u_r), M>=length(u_c)



len_ur = length(u_r);
len_uc = length(u_c);

filter_matrix = u_c.'*u_r;

xLayer = len_uc-1;
yLayer = len_ur-1;
ve = padarray(v,[xLayer yLayer],'circular','post');

y = conv2(ve,filter_matrix,'valid');

highest_order_r = stp_r + len_ur -1;
highest_order_c = stp_c + len_uc -1;

y = circshift2d(y, highest_order_c, highest_order_r);


end

