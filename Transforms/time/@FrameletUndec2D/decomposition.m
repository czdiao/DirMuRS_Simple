function [ w ] = decomposition( obj, x )
%DECOMPOSITION Decomposition of 2D Undecimated Framelet Transform.
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
    [ x, H ] = d2tanalysis( x, 1, FB_col, FB_row );
    w{ilevel} = H;
    
    % As to undecimated transforms, the filters need to be upsampled after
    % each level
    FB_col = FB_col.upsamplefilter(2);
    FB_row = FB_row.upsamplefilter(2);
end

w{nL+1} = x;



end

