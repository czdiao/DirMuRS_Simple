function w = fupsample( fdata, rate, dim  )
%FUPSAMPLE Upsample of the data in frequency domain.
%   Calculate \hat{data\up rate}(\xi) from \hat{data}(\xi)
%   All \xi \in [0, 2*pi).
%   If len = size(fdata, dim), then size(w, dim) = len*rate.
%
%   Input:
%       fdata:
%           data in frequency domain. Could be 1D/2D/3D.
%       rate:
%           upsampling rate. Should be integer.
%       dim:
%           along this dimension to perform upsampling. Could be omitted
%           for vector(row/col) fdata.
%
%   Output:
%       w:
%           upsampled data in frequency domain.
%           size(w,dim) = rate*size(fdata,dim)
%
%   Author: Chenzhe Diao.

%% set dim for vector fdata
if isrow(fdata)
    dim = 2;
elseif iscolumn(fdata)
    dim = 1;
end

if dim>ndims(fdata)
    error('Data is in a lower dim space!');
end

%% Upsample

r = ones(1, ndims(fdata));
r(dim) = rate;
w = repmat(fdata,r);




end

