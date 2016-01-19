function [ Wsig ] = local_variance( data, windowsize )
%LOCAL_VARIANCE Calculate the local variance of data in a window, assumed
%to be zero mean.
%   Wsig = sqrt(\sum_i abs(data_i)^2/N),    for all data_i in the local
%           window. N is the number of elements in the window.
%
%Input:
%   data:  matrix
%
%   Note:   This function can accept complex input data. The output would
%           be the variance of its magnitude.
%
% Chenzhe
% Jan, 2016

% Estimated variance
if nargin == 1
    windowsize = 7;
end

windowfilt = ones(1,windowsize)/windowsize;
Wsig = conv2(windowfilt,windowfilt,(abs(data)).^2,'same');

Wsig = max(sqrt(Wsig), eps);



end

