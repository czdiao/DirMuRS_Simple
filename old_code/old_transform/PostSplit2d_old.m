function [ W_new ] = PostSplit2d_old( W, u, dim )
%PostSplit2d
%   Split the filter with (u1, u2) by post-possessing the wavelet coefficients
%   Input:
%       W:            2d wavelet coefficient, should be a matrix
%       u:            1d filter used to split the coefficients
%       dim:          1 or 2, which dimension to split, 1 for rows, 2 for columns


%flip the filter
len = length(u.filter);
start_pt = (u.start_pt + len - 1) * (-1);

filter = u.filter(end:-1:1);


% [M, N] = size(W);
% if (N<length(af_row))||(M<length(af_col))
%     disp('Error: signal is shorter than the filter in analysis operation!\n');
% end

% The other dim is only a dirac sequence
if dim == 1 % row
    W_new = d2tconv_fir(W, filter, start_pt, 1, 0);
elseif dim == 2   % col
    W_new = d2tconv_fir(W, 1, 0,filter, start_pt);
end



end

