function [ y ] = tupsample( data, rate, dim )
%TUPSAMPLE Upsample of the data in time domain.
%
%   Author: Chenzhe Diao

if isrow(data)
    dim = 2;
elseif iscolumn(data)
    dim = 1;
end

sz = size(data);
sz(dim) = sz(dim)*rate;

y = zeros(sz);
ind = 1:rate:sz(dim);

if isvector(data)
    y(ind) = data;
elseif ismatrix(data)
    if dim==1
        y(ind,:) = data;
    elseif dim==2
        y(:,ind) = data;
    else
        error('Wrong dim!');
    end
elseif ndims(data)==3
    if dim==1
        y(ind,:,:) = data;
    elseif dim==2
        y(:,ind,:) = data;
    elseif dim==3
        y(:,:,ind) = data;
    else
        error('Wrong dim!');
    end
else
    error('Wrong data dimension!');
end




end

