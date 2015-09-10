function w = tconv( f1d, data, dim )
%TCONV Convolution of the filter and data in time domain.
%        1) w = tconv(f1d, data, dim)
%        2) w = f1d.tconv(data,dim)
%
%Input:
%   f1d:
%       filter1d object. 1D filter.
%   data:
%       1D/2D/3D data.
%   dim:
%       dimension of the data to perform convolution.
%       Could be omitted if data is a vector.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015


% set dim for vector fdata
if isrow(data)
    dim = 2;
elseif iscolumn(data)
    dim = 1;
end

M = size(data, dim);
if M<length(f1d.filter)
    error('Error: signal is shorter than the filter in tconv!');
end

len = length(f1d.filter);
Layer = len-1;

if max(abs(data(:)))<=eps    % if data==0, set w=0. To be faster in calculating the filter norms
    w = zeros(size(data));
else
    switch ndims(data)
        case 2
            if dim==1
                order = [1,2];
            elseif dim==2
                order = [2,1];
            else
                error('Wrong input dimension!');
            end
            
            data = permute(data, order);
            w = upfirdn(data, f1d.filter);
            N = size(data,1);
            w(N+(1:Layer),:) = w(1:Layer,:) + w(N+(1:Layer),:);
            w = w(Layer+1:end, :);
            highest_order = f1d.start_pt + len -1;
            w = circshift2d(w, highest_order, 0);
            w = ipermute(w, order);
            
        case 3
            if dim==1
                order = [1,2,3];
            elseif dim==2
                order = [2,1,3];
            elseif dim==3
                order = [3,1,2];
            else
                error('Wrong input dimension!');
            end
            
            data = permute(data, order);
            w = upfirdn(data, f1d.filter);
            N = size(data,1);
            w(N+(1:Layer),:,:) = w(1:Layer,:,:) + w(N+(1:Layer),:,:);
            w = w(Layer+1:end, :, :);
            highest_order = f1d.start_pt + len -1;
            w = circshift3d(w, highest_order, 0, 0);
            w = ipermute(w, order);
        otherwise
            error('Data dim more than 3!');
    end
end


end

