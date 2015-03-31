function [ n ] = Filter2SqNorm( filter2d )
%FILTER2SQNORM Summary of this function goes here
%   Detailed explanation goes here

n = filter2d.row_filter*filter2d.row_filter';
n = n * filter2d.col_filter*filter2d.col_filter';

end

