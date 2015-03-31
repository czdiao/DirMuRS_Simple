function y = d2tconv_new( v,u_r,stp_r,u_c,stp_c)
%D2TCONV_NEW 2D time domain convolution
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


[M, N] = size(v);

u_row_flip = u_r(end:-1:1)';
u_col_flip = u_c(end:-1:1)';

len_ur = length(u_r);
len_uc = length(u_c);

% row convolution
v = [v, v(:, 1:len_ur-1)];    % periodic extension (len_ur-1) on the right
tmp = zeros(M,N);
for i = 1:N
    tmp(:, i) = v(:,i:(i+len_ur-1)) * u_row_flip;
end

highest_order_r = stp_r + len_ur -1;


% column convolution
tmp = tmp';
tmp = [tmp, tmp(:, 1:len_uc-1)];  % periodic extension (len_uc-1) at the bottom
y = zeros(N,M);
for i = 1:M
    y(:, i) =  tmp(:, i:(i+len_uc-1)) * u_col_flip;
end

highest_order_c = stp_c + len_uc -1;

y = y';
%y = circshift(y, [highest_order_c, highest_order_r]);
y = circshift2d(y, highest_order_c, highest_order_r);








end

