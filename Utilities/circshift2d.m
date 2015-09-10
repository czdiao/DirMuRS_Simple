function [ y ] = circshift2d( x, row, col )
%CIRCSHIFT2D Summary of this function goes here
%   Detailed explanation goes here
%   Author: Chenzhe Diao

[M, N] = size(x);

m = 0:M-1;
n = 0:N-1;

m = mod(m-row, M);
n = mod(n-col, N);
y = x(m+1,n+1);




end

