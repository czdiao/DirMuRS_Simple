function [ ffb2 ] = conj_ffilter( ffb1 )
%CONJ_FFILTER Find the conjugate of the 2D (time domain) complex filter.
%
%   \hat{bn} = conj_filter(\hat{bp})
%
%   The input and output can both be filter banks
%
%   Chenzhe
%   Feb, 2016
%

len = length(ffb1);
ffb2 = ffb1;

for i = 1:len
    f = ffb1(i).ffilter;
    f = fconj(f);
    ffb2(i).ffilter = f;
    if ~isempty(ffb1(i).index)
        ffb2(i).index = -ffb1(i).index;
    end
end





end

