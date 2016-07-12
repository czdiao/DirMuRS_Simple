function  y  = reconstruction( obj )
%RECONSTRUCTION Reconstruction of fFrameletMultiLvFB2D transform
%
%
%   Chenzhe
%   Jun, 2016
%

w = obj.coeff;
nL = obj.nlevel;

w1 = cell(1,2);
w1{2} = w{nL+1};
for j = 1:nL
    w1{1} = [w1{1}, w{j}];
end

obj.nlevel = 1;
obj.coeff = w1;     % changed only inside this function
y = reconstruction@TPCTF2D(obj);


end

