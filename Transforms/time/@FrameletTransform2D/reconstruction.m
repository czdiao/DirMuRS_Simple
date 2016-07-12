function y = reconstruction(obj)
%RECONSTRUCTION Reconstruction of time domain framelet 2D transform
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
    coeff = [LL, w{ilevel}];
    LL = d2tsynthesis( coeff, 2, FB_col, FB_row );
end

y = LL;



end

