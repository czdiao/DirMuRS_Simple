function x = synthesis_new(FilterBank, datacells, rate, dim)
%SYNTHESIS Time domain Synthesis Operation.
%       1)  x = synthesis(FilterBank, datacells, rate, dim)
%       2)  x = synthesis(FilterBank, vectorcells, rate)
%Input:
%   FilterBank:
%       filter1d array. Time domain filter bank for synthesis operation.
%   datacells:
%       Cell array of data. Each cell contains data in each band.
%   rate:
%       Upsampling rate in synthesis operation.
%   dim:
%       Dimension along which to perform synthesis operation.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015


if isrow(datacells{1})
    dim = 2;
elseif iscolumn(datacells{1})
    dim = 1;
end

Nfilters = length(FilterBank);
if length(datacells)~=Nfilters
    error('Number of filters does not match the number of coeff in synthesis!');
end


switch ndims(datacells{1})
    case 2
        if dim==1
            order = [1,2];
        elseif dim==2
            order = [2,1];
        else
            error('Wrong input dimension!');
        end
        
        sz = size(datacells{1});
        sz = sz(order);
        sz(1) = sz(1)*rate;
        x = zeros(sz);
        
        for i = 1:Nfilters
            data = permute(datacells{i}, order);
            w = upfirdn(data, FilterBank(i).filter, rate, 1);
            N = size(data,1);
            w(N+(1:Layer),:) = w(1:Layer,:) + w(N+(1:Layer),:);
            w = w(Layer+1:end, :);
            highest_order = f1d.start_pt + len -1;
            w = circshift2d(w, highest_order, 0);
            w = ipermute(w, order);
        end
        
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
        
        sz = size(datacells{1});
        sz = sz(order);
        sz(1) = sz(1)*rate;
        x = zeros(sz);
        
        for i = 1:Nfilters
            data = permute(data, order);
            w = upfirdn(data, f1d.filter);
            N = size(data,1);
            w(N+(1:Layer),:,:) = w(1:Layer,:,:) + w(N+(1:Layer),:,:);
            w = w(Layer+1:end, :, :);
            highest_order = f1d.start_pt + len -1;
            w = circshift3d(w, highest_order, 0, 0);
            w = ipermute(w, order);
        end
    otherwise
        error('Data dim more than 3!');
end






for i = 1:Nfilters
    
    
    
%     dataup = tupsample(datacells{i}, rate, dim ); %upsample the data
%     x = x + tconv(FilterBank(i), dataup, dim);
end
x = x*sqrt(rate);


% if isrow(datacells{1})
%     dim = 2;
% elseif iscolumn(datacells{1})
%     dim = 1;
% end




end

