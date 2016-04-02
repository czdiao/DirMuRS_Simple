function [ f2 ] = upsamplefilter( ffilter_old, rate )
%UPSAMPLEFILTER Upsample of the filter.
%
%   This corresponds to the upsample of the filter in time domain.
%
%   Chenzhe
%   Mar, 2016
%

f2 = ffilter_old;
f2.ffilter = fupsample(f2.ffilter, rate);


end

