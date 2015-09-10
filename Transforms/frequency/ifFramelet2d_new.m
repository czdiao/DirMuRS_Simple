function [ fdata ] = ifFramelet2d_new( w, J, FfilterBank_col, FfilterBank_row )
%IFFRAMELET2D_NEW Summary of this function goes here
%   Detailed explanation goes here


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

