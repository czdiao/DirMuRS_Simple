function [ data ] = iFramelet2d( w, J, FilterBank_col, FilterBank_row )
%IFRAMELET2D 2-D Inverse Framelet Transform
%
%
%   Author: Chenzhe Diao


if nargin == 3
    FilterBank_row = FilterBank_col;
end

LL = w{J+1};


for ilevel = J:(-1):1
    coeff = [LL, w{ilevel}];
    LL = d2tsynthesis( coeff, 2, FilterBank_col, FilterBank_row );
end

data = LL;



end

