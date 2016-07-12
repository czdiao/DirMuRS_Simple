function  w  = decomposition( obj, x )
%DECOMPOSITION fFrameletMultiLvFB2D decomposition.
%
%   The transform is implemented using 2d filter freqfilter2d.
%
%   Chenzhe
%   Jun, 2016
%

nL = obj.nlevel;
w = cell(nL+1);

obj.nlevel = 1;     % only changed temporarily in this function. Not changed outside.
w1 = decomposition@TPCTF2D(obj, x);

count = 0;
for j = 1:nL
    index = count+1 : count+obj.nband(j);
    w{j} = w1{1}(index);
    count = count + obj.nband(j);
end
w{nL+1} = w1{2};


end

