function [ y ] = hard( x, T )
%HARD Hard Thresholding function
%
%   Chenzhe
%   Feb, 2016

y = x;
y(abs(y)<T)=0;




end

