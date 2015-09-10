function [ data ] = iFramelet1d_new( w, J, FilterBank )
%IFRAMELET1D_NEW Summary of this function goes here
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

