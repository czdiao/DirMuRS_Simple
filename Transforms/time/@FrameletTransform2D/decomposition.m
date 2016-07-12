function [ w ] = decomposition( obj, x )
%DECOMPOSITION Decomposition of FrameletTransform2D.
%
%
%   Chenzhe
%   April, 2016
%

nL = obj.nlevel;
FB_col = obj.FilterBank_col;
FB_row = obj.FilterBank_row;

w = cell(1, nL+1);

for ilevel = 1:nL
    [ x, H ] = d2tanalysis( x, 2, FB_col, FB_row );
    w{ilevel} = H;
end

w{nL+1} = x;



end

