function [ w ] = Framelet2d_new( data, J, FilterBank_col, FilterBank_row )
%FRAMELET2D_NEW Summary of this function goes here
%   Detailed explanation goes here
%
%   Author: Chenzhe Diao

if nargin == 3
    FilterBank_row = FilterBank_col;
end


w = cell(1, J+1);
for ilevel = 1:J
    [data, H] = d2tanalysis( data, 2, FilterBank_col, FilterBank_row );
    w{ilevel} = H;
end

w{J+1} = data;



end

