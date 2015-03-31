% removeBoundary : Remove boundary segment of an image
% 
% r = removeBoundary(im,boundary_size)
%
% Inputs:
% im : input image
% boundary_size : thickness (in pixels) of boundary segment to remove
%
% Outputs:
% r - resulting trimmed array
% 
% See also extendBoundary

function r = removeBoundary(im,boundary_size)
[M,N]=size(im);
r=im(1+boundary_size:M-boundary_size,1+boundary_size:N-boundary_size);
