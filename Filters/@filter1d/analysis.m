function [ w ] = analysis( f1d, data, rate, dim )
%ANALYSIS Time domain Analysis operation of single filter.
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
%   Note:
%       This is a fater implementation. Combined the process of convolution
%       and downsampling process using the upfirdn function.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

% checkfilter should be called first, to make the decimation work.
f1d = checkfilter(f1d, rate);
f1d_flip = conjflip(f1d);

if isvector(data)
    
    if length(data)<length(f1d_flip.filter)
        error('Error: signal is shorter than the filter in analysis operation!');
    end
    
    w = upfirdn(data, f1d_flip.filter, 1, rate);    % convolution and downsample
    Layer_new = (length(f1d_flip.filter)-1)/rate;
    
    if mod(length(data), rate)~=0
        error('Data length is not multiples of the decimation rate!');
    end
    
    N = length(data)/rate;
    w(N+(1:Layer_new)) = w(1:Layer_new) + w(N+(1:Layer_new));
    w = w(Layer_new+1:end);
    h = f1d_flip.start_pt/rate + Layer_new;
    w = circshift1d(w, h);
    w = w*sqrt(rate);
    
elseif ismatrix(data)
    if dim==1
        order = [1,2];
    elseif dim==2
        order = [2,1];
    else
        error('Wrong input dimension!');
    end
    
    if size(data,dim)<length(f1d_flip.filter)
        error('Error: signal is shorter than the filter in analysis operation!');
    end
    
    data = permute(data, order);
    w = upfirdn(data, f1d_flip.filter, 1, rate);    % convolution and downsample
    Layer_new = (length(f1d_flip.filter)-1)/rate;
    
    if mod(size(data, 1), rate)~=0
        error('Data length is not multiples of the decimation rate!');
    end
    
    N = size(data, 1)/rate;
    w(N+(1:Layer_new), :) = w(1:Layer_new, :) + w(N+(1:Layer_new), :);
    w = w(Layer_new+1:end, :);
    h = f1d_flip.start_pt/rate + Layer_new;
    w = circshift2d(w, h, 0);
    w = w*sqrt(rate);
    w = ipermute(w, order);
    
elseif ndims(data)==3
    if dim==1
        order = [1,2,3];
    elseif dim==2
        order = [2,1,3];
    elseif dim==3
        order = [3,1,2];
    else
        error('Wrong input dimension!');
    end
    
    if size(data,dim)<length(f1d_flip.filter)
        error('Error: signal is shorter than the filter in analysis operation!');
    end
    
    data = permute(data, order);
    w = upfirdn(data, f1d_flip.filter, 1, rate);    % convolution and downsample
    Layer_new = (length(f1d_flip.filter)-1)/rate;
    
    if mod(size(data, 1), rate)~=0
        error('Data length is not multiples of the decimation rate!');
    end
    N = size(data, 1)/rate;
    w(N+(1:Layer_new), :, :) = w(1:Layer_new, :, :) + w(N+(1:Layer_new), :, :);
    w = w(Layer_new+1:end, :, :);
    h = f1d_flip.start_pt/rate + Layer_new;
    w = circshift3d(w, h, 0, 0);
    w = w*sqrt(rate);
    w = ipermute(w, order);

else
    error('Data Dimension Too High!');
end







end

