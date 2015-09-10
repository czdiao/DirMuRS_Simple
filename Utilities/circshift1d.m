function [ y ] = circshift1d( x, k )
%CIRCSHIFT_NEW General Version of circular shift.
%Input:
%   x:
%       Input data array.
%   k:
%       Shift distance.
%Output:
%   y:
%       Shifted data.
%Example:
% >> x = 1:5;
% >> y = circshift(x, 1)
% >> y =
% >>     5     1     2     3     4
%
%   Author: Chenzhe Diao
%   Date:   July, 2015


len = length(x);

m = 0:len-1;

m = mod(m-k, len);
y = x(m+1);



end

