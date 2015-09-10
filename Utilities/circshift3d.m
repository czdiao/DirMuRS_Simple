function [ y ] = circshift3d( x, nd1, nd2, nd3  )
%CIRCSHIFT3D Summary of this function goes here
%   Detailed explanation goes here
%
%   Author: Chenzhe Diao

[M, N, R] = size(x);

m = 0:M-1;
n = 0:N-1;
r = 0:R-1;

m = mod(m-nd1, M);
n = mod(n-nd2, N);
r = mod(r-nd3, R);
y = x(m+1,n+1, r+1);




end

