function [ data ] = iFramelet1d( w, J, FilterBank )
%IFRAMELET1D 1-D Inverse of Framelet Transform
%   Detailed explanation goes here
%
%   Author: Chenzhe Diao


LL = w{J+1};

for ilevel = J:(-1):1
    coeff = [LL, w{ilevel}];
    LL = synthesis(FilterBank, coeff, 2);
end

data = LL;



end

