% makeInteriorMask : return logical mask for interior region
%
% returns a logical array with dimension dim, with a rectangular inner
% region filled with 1's and a boundary region of thickness boundary
% filled with 0's
%
% Inputs:
% dim - size of desired output
% boundary - thickness of boundary segment
%
% Outputs:
% r - output logical array

function r= makeInteriorMask(dim,boundary_size)
r = extendBoundary(removeBoundary(ones(dim),boundary_size),...
                   boundary_size,'method','zeros');
r = logical(r);
