function [ L, H ] = d2tanalysis( data, rate, fb_c, fb_r )
%D2TANALYSIS 2D Analysis operatoin given col and row filter banks.
%Usage:
%   [L, H] = d2tanalysis(data, rate, fb_c, fb_r)
%
%Input:
%   data:
%       2D data matrix.
%   rate:
%       Downsampling rate in analysis operation. Use 2 for default wavelet.
%   fb_c:
%       filter1d array. 1D filter bank for analysis operation on columns.
%   fb_r:
%       filter1d array. 1D filter bank for analysis operation on rows.
%
%Output:
%   L :
%       2D Matrix. Output of LL filer.
%   H :
%       Cell array. Output of all highpass filters.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

if nargin == 3
    fb_r = fb_c;
end

len_c = length(fb_c);
len_r = length(fb_r);

num_hi = len_c*len_r-1;

H = cell(1, num_hi);

tmp = analysis(fb_c(1), data, rate, 1);
L = analysis(fb_r(1), tmp, rate, 2);
count = 1;
for i = 2:len_r
    H{count} = analysis(fb_r(i), tmp, rate, 2);
    count = count+1;
end

for j = 2:len_c
    tmp = analysis(fb_c(j), data, rate, 1);
    for i = 1:len_r
        H{count} = analysis(fb_r(i), tmp, rate, 2);
        count = count+1;
    end
end



end

