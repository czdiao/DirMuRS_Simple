function [ y ] = symrotate( x, angle )
%SYMROTATE Symmetric extend input image, and rotate.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);


y = imrotate(x,angle,'bilinear','crop');

ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);



end

