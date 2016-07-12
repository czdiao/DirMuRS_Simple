function [ fb1d ] = SplineCubic1d
%SPLINECUBIC Piecewise Cubic, B-spline framelet
%
%
%   Chenzhe
%   April, 2016
%

low = filter1d([1 4 6 4 1]/16, -2, 'low');
hi1 = filter1d([1 2 0 -2 -1]/8, -2, 'hi1');
hi2 = filter1d([-1 0 2 0 -1]/16*sqrt(6), -2, 'hi2');
hi3 = filter1d([-1 2 0 -2 1]/8, -2, 'hi3');
hi4 = filter1d([1 -4 6 -4 1]/16, -2, 'hi4');

fb1d = [low, hi1, hi2, hi3, hi4];


end

