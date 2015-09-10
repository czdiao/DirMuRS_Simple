function [ x ] = d2fsynthesis( w, rate, Ffb_c, Ffb_r )
%D2FSYNTHESIS Summary of this function goes here
%   Detailed explanation goes here


if nargin == 3
    Ffb_r = Ffb_c;
end

len_r = length(Ffb_r);
len_c = length(Ffb_c);

tmp = cell(1, len_c);

for i = 1:len_c
    ind = (i-1)*len_r+1 : i*len_r;
    tmp{i} = fsynthesis(Ffb_r, w(ind), rate, 2);
end

x = fsynthesis(Ffb_c, tmp, rate, 1);


end

