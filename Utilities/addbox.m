function [ img_new ] = addbox( img, x_start, x_inc, y_start, y_inc )
%ADDRECTANGLE Add a rectangle box to the image
%
%Input:
%   img:
%       original image, a matrix of class double
%   x_start:
%       the starting point of the box in the first dimension (row index)
%   x_inc:
%       the increment (box side length) in the first dimension.
%   y_start, y_inc:
%       similar to x_start, x_inc, in the second dimension (column index)
%
%   Note:
%       The box boundary is set to the smallest pixcel value (usually the
%       darkest in the plot).
%       The box is of size x_inc * y_inc, including both sides boundaries.
%
%   Chenzhe Diao
%   Jan, 2016
%


c = min(img(:));

img_new = img;

x_end = x_start + x_inc -1;
y_end = y_start + y_inc -1;

img_new(x_start, y_start:y_end) = c;
img_new(x_end, y_start:y_end) = c;

img_new(x_start:x_end, y_start) = c;
img_new(x_start:x_end, y_end) = c;




end

