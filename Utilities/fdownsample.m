function  w  = fdownsample( fdata, rate, dim )
%FDOWNSAMPLE Downsample in frequency domain.
%   Calculate \hat{data\down rate}(\xi) from \hat{data}(\xi)
%   All \xi \in [0, 2*pi).
%   If len = size(fdata, dim), then size(w, dim) = len/rate.
%
%   Input:
%       fdata:
%           data in frequency domain. Could be 1D/2D/3D.
%       rate:
%           downsampling rate. Should be integer.
%           length of fdata should be multiples of rate (in dimension=dim).
%       dim:
%           along this dimension to perform downsampling. Could be omitted
%           for vector(row/col) fdata.
%
%   Output:
%       w:
%           downsampled data in frequency domain.
%           size(w,dim) = size(fdata,dim)/rate
%
%   Author: Chenzhe Diao.
%   Date:   July, 2015

%% set dim for vector fdata
if isrow(fdata)
    dim = 2;
elseif iscolumn(fdata)
    dim = 1;
end

if dim>ndims(fdata)
    error('Data is in a lower dim space!');
end

%% Downsample
switch ndims(fdata)
    case 2
        if dim==1   % along columns
            order = [1,2];
        elseif dim==2   % along rows
            order = [2,1];
        else
            error('Wrong Input dim!');
        end
        fdata = permute(fdata, order);
        sz = size(fdata);
        sz(1) = sz(1)/rate;
        L = sz(1);
        w = zeros(sz);
        ind = 1:L;
        for i = 0:rate-1
            w = w + fdata(ind+i*L,:);
        end
        w = ipermute(w, order);
        
    case 3
        if dim ==1
            order = [1,2,3];
        elseif dim==2
            order = [2,1,3];
        elseif dim ==3
            order = [3,1,2];
        else
            error('Wrong Input dim!');
        end
        
        fdata = permute(fdata, order);
        sz = size(fdata);
        sz(1) = sz(1)/rate;
        L = sz(1);
        w = zeros(sz);
        ind = 1:L;
        for i = 0:rate-1
            w = w + fdata(ind+i*L,:,:);
        end
        w = ipermute(w, order);
        
    otherwise
        error('Wrong Data Dimension!');
end % switch
w = w/rate;


end

