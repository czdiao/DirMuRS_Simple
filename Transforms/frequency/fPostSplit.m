function [ W_new ] = fPostSplit( W, u, dim )
%FPOSTSPLIT Summary of this function goes here
%   Detailed explanation goes here


% conjugate flip the filter
u.ffilter = conj(u.ffilter);

W_new = fconv(u, W, dim);




end

