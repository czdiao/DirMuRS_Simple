function [ L, H ] = d2fanalysis( fdata, rate, Ffb_c, Ffb_r )
%D2FANALYSIS Summary of this function goes here
%   Detailed explanation goes here

if nargin == 3
    Ffb_r = Ffb_c;
end

len_c = length(Ffb_c);
len_r = length(Ffb_r);

num_hi = len_c*len_r-1;

H = cell(1, num_hi);

tmp = fanalysis(Ffb_c(1), fdata, rate, 1);
L = fanalysis(Ffb_r(1), tmp, rate, 2);
count = 1;
for i = 2:len_r
    H{count} = fanalysis(Ffb_r(i), tmp, rate, 2);
    count = count+1;
end

for j = 2:len_c
    tmp = fanalysis(Ffb_c(j), fdata, rate, 1);
    for i = 1:len_r
        H{count} = fanalysis(Ffb_r(i), tmp, rate, 2);
        count = count+1;
    end
end



end

