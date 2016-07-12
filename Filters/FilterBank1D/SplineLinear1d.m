function fb1d  = SplineLinear1d
%SPLINELINEAR Piecewise Linear, B-spline framelet
%
%
%
%
%   Chenzhe
%   April, 2016
%

low = filter1d([1, 2, 1]/4, -1, 'low');
h1 = filter1d([1, 0, -1]/4*sqrt(2), -1, 'hi1');
h2 = filter1d([-1, 2, -1]/4, -1, 'hi2' );

fb1d = [low, h1, h2];



end

