function [ ffilterb2 ] = conj_ffilter( ffilterb1 )
%CONJ_FILTER Find the conjugate of the 1D (time domain) complex filter.
%
%   \hat{bn} = conj_filter(\hat{bp})
%
%   The input and output can be both filter banks
%
%   Chenzhe
%   Feb, 2016
%

len = length(ffilterb1);
ffilterb2 = ffilterb1;

for i = 1:len
    f = ffilterb1(i).ffilter;
    f = fconj(f);
    ffilterb2(i).ffilter = f;
    
    if ~isempty(ffilterb1(i).index)
        ffilterb2(i).index = -ffilterb1(i).index;
    end
end





end

