function [ y ] = iFramelet2d( w, J, FS_filter2d, filterbank2d )
%iFramelet2d 2D Inverse Framelet Transform
%   Inverse of Framelet2d() function
%
%	See Framelet2d() documentation for explaination of input and output

if nargin == 3  % same filter bank for all levels
    filterbank2d = FS_filter2d;
end

LL = w{J+1};
for j = J:(-1):2
    coeff = [LL, w{j}];
    LL = synthesis2d(coeff, filterbank2d);
end

coeff = [LL, w{1}];
LL = synthesis2d(coeff, FS_filter2d);

y = LL;



end

