function [ f ] = convfilter1d( u, v )
%CONVFILTER1D Convolve 2 1d filters
%   Compute the convolution as polynomials multiplication in Z domain.
%   Input:      
%           u, v:   1d filters.
%   Output:
%           f:      1d filter. f = u*v

f.start_pt = u.start_pt + v.start_pt;

lenu = length(u.filter);
lenv = length(v.filter);
lenf = lenu + lenv - 1;

f.filter = zeros(1, lenf);

for i = 1:lenv
    f.filter(i:(i+lenu-1)) = f.filter(i:(i+lenu-1)) + v.filter(i)*u.filter;
end


end

