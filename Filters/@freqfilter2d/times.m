function obj2 = times(C, obj1)
%TIMES Scalar multiplication of freqfilter2d filters.
%
%   We need to use obj2 = C .* obj1
%
%   Chenzhe
%   Feb, 2016
%

obj2 = obj1;
obj2.ffilter = C .* obj1.ffilter;



end

