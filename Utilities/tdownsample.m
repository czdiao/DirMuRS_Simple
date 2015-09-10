function [ y ] = tdownsample( data, rate, dim )
%TDOWNSAMPLE Downsample in time domain.
%
%   Author: Chenzhe Diao


if isvector(data)
    y = data(1:rate:end);
elseif ismatrix(data)
    if dim==1
        y = data(1:rate:end,:);
    elseif dim==2
        y = data(:,1:rate:end);
    else
        error('Wrong dim!');
    end
elseif ndims(data)==3
    if dim==1
        y = data(1:rate:end,:,:);
    elseif dim==2
        y = data(:,1:rate:end,:);
    elseif dim==3
        y = data(:,:,1:rate:end);
    else
        error('Wrong dim!');
    end
else
    error('Wrong dimension!');
end


end

