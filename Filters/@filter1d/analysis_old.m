function [ w ] = analysis_old( f1d, data, rate, dim )
%ANALYSIS Time domain Analysis operation of single filter.
%   NOTE:
%       This is an old implementation. The result should be the same as
%       analysis.m function. Much slower for large data size.
%
%       1)  w = analysis(f1d, data, rate, dim)
%       2)  w = f1d.analysis(f1d, data, rate)
%       3)  w = analysis(f1d, vectordata, rate)
%
%Input:
%   f1d:
%       filter1d object. 1D filter for analysis operation.
%   data:
%       1D/2D/3D data.
%   rate:
%       Downsampling rate in analysis operation. Use 2 for default wavelet.
%   dim:
%       Dimension of data to perform analysis operation.
%       Could be omitted if data is a vector.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

if isrow(data)
    dim = 2;
elseif iscolumn(data)
    dim = 1;
end

%conjugate flip of the filter
f1d_flip = conjflip(f1d);

w = tconv(f1d_flip, data, dim);
w = tdownsample(w, rate, dim);

w = w*sqrt(rate);


end

