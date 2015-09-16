function [ u1, u2 ] = SplitHaar
%SPLITHAAR Two Haar Filters. Used to split the highpass filters.
%
%   Chenzhe Diao

u1 = filter1d([-0.5, 0.5],-1);
u2 = filter1d([-0.5, -0.5], -1);


end

