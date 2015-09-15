function [ fdata ] = ifFramelet2d( w, J, FfilterBank_col, FfilterBank_row )
%IFFRAMELET2D 2-D Inverse of Frequency-based Framelet Transform
%
%   Chenzhe Diao



if nargin == 3
    FfilterBank_row = FfilterBank_col;
end

LL = w{J+1};


for ilevel = J:(-1):1
    coeff = [LL, w{ilevel}];
    LL = d2fsynthesis( coeff, 2, FfilterBank_col, FfilterBank_row );
end

fdata = LL;



end

