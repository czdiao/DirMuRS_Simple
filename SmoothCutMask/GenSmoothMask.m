function [ smoothmask ] = GenSmoothMask( logicmask, r )
%GENSMOOTHMASK Generate a mask, to smoothly cut the 2D image at specific
%locations.
%
%Input:
%   logicmask:
%       Logical matrix, to specify the location of pixels in the original
%       image to be saved. The size should be the same as the original
%       image.
%   r:
%       Smoothing radius
%       
%Output:
%   smoothmask:
%       The generated smoothing mask. It is a matrix of the same size as
%       the logicalmask. At the locations specified by the logicalmask, the
%       value would be 1. If the position is far away from thoses specified
%       by the logicalmask (dist > r), the value would be 0. The values at
%       other locations would be in [0,1], we tried to make it a C^\inf
%       surface.
%
%   Chenzhe
%   Feb, 2016
%

dist_mat = PointSetDist(logicmask, r);
dist_mat(dist_mat>=r) = r;

smoothmask = cos(dist_mat/r*pi/2);







end

