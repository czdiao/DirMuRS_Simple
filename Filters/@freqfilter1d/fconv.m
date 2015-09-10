function w = fconv(Ffilter, fdata, dim)
%FCONV Convolution in Frequency Domain.
%Input:
%   Ffilter:   
%       ffilter1d object.
%       Length of the Ffilter could be multiples of the length of fdata. 
%       Will downsample the filter automatically.
%   fdata:   
%       N-D data in frequency domain. Only support upto 3D data now.
%   dim:   
%       dimension to perform the convolution. Could be ommited if fdata is a vector.
%           dim = 1 for convolution along each col
%           dim = 2 for convolution along each row
%           dim = 3 for the 3rd dimension for 3D data.
%       Could be omitted if fdata is a vector.
%Output:
%   w   :   
%       convolution of the Frequency based filter and the data along dimension 'dim'.
%           Output w also in frequency domain.
%
%   Author: Chenzhe Diao
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

%% Get Correct Filter Sampling rate in Frequency Domain.
M = size(fdata,dim);
len = length(Ffilter.ffilter);
if mod(len, M)~=0
    error('Frequency-based Filter Sampling Rate Does not match the data size!');
else
    rate = len/M;
    Ffilter = filterdownsample(Ffilter, rate);
end

%% Copy ffilter to the same size as fdata.
tmp = Ffilter.ffilter;
switch ndims(fdata)
    case 2
        if dim==1   % along columns
            tmp = repmat(tmp.',[1, size(fdata,2)]);
        elseif dim==2   % along rows
            tmp = repmat(tmp, [size(fdata,1), 1]);
        else
            error('Wrong Input dim!');
        end
    case 3
        if dim==1   % along columns
            tmp = repmat(tmp.', [1, size(fdata,2), size(fdata,3)]);
        elseif dim==2   % along rows
            tmp = repmat(tmp, [size(fdata,1), 1, size(fdata,3)]);
        elseif dim==3   % along the 3rd dimension
            tmp = reshape(tmp, 1,1,[]);
            tmp = repmat(tmp, [size(fdata,1), size(fdata,2), 1]);
        else
            error('Wrong Input dim!');
        end
    otherwise
        error('Wrong Data Dimension!');
end %switch

%% Convolution is just product in frequency domain.
w = fdata.*tmp;

end %fconv


