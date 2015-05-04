function [ y ] = iFramelet2d( w, J, FS_filter2d, filter2d )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


LL = w{J+1};
for j = J:(-1):2
    coeff = [LL, w{j}];
    LL = synthesis2d(coeff, filter2d);
end

coeff = [LL, w{1}];
LL = synthesis2d(coeff, FS_filter2d);

y = LL;



end

