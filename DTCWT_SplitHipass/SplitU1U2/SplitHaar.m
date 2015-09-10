function [ u1, u2 ] = SplitHaar
%SPLITHAAR Summary of this function goes here
%   Detailed explanation goes here

u1 = filter1d([-0.5, 0.5],-1);
u2 = filter1d([-0.5, -0.5], -1);


end

