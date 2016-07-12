function y = reconstruction(obj)
%RECONSTRUCTION Reconstruction of undecimated time domain 2D framelet
%transform.
%
%
%   Chenzhe
%   April, 2016
%

FB_col = obj.FilterBank_col;
FB_row = obj.FilterBank_row;
w = obj.coeff;
J = obj.nlevel;

LL = w{J+1};


for ilevel = J:(-1):1
    % For undecimated transform, the filters used at each level
    FB_colj = FB_col.upsamplefilter(2^(ilevel-1));
    FB_rowj = FB_row.upsamplefilter(2^(ilevel-1));
    
    coeff = [LL, w{ilevel}];
    LL = d2tsynthesis( coeff, 1, FB_colj, FB_rowj );
end

y = LL;


end

