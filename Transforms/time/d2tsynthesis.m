function [ x ] = d2tsynthesis( w, rate, fb_c, fb_r )
%D2TSYNTHESIS 2D synthesis operation given col and row filter banks.
%Input:
%   w:
%       cell array storing coefficients in each band. For example:
%       w{1} = LL; w{2} = LH; w{3} = HL; w{4} = LL.
%       See d2tanalysis.
%   rate:
%       upsampling rate in the transform.
%   fb_c:
%       filter bank for column operation.
%   fb_r:
%       filter bank for row operation.
%
%Output:
%   x:
%       recovered data.
%
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

if nargin == 3
    fb_r = fb_c;
end

len_r = length(fb_r);
len_c = length(fb_c);

tmp = cell(1, len_c);

for i = 1:len_c
    ind = (i-1)*len_r+1 : i*len_r;
    tmp{i} = synthesis(fb_r, w(ind), rate, 2);
end

x = synthesis(fb_c, tmp, rate, 1);

end

