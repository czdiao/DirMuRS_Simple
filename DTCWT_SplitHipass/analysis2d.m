function  w  = analysis2d( v, af )
%analysis2d Apply 2d analysis filter on 2d signal
%   Apply a 2d (tensor-product) filter on a 2d signal
%
%   Input:  
%       v:          Input signal, 2d matrix. All directions start from
%                   index = 0. Periodic extension.
%       af:         2d analyisis filter
%   Note:
%       We need the signal length larger than filter length.
%       [M, N] = size(v),  then N>=length(af_row), M>=length(af_col)



%flip the filter
row_len = length(af.row_filter);
col_len = length(af.col_filter);
row_start_pt = (af.row_start_pt + row_len - 1) * (-1);
col_start_pt = (af.col_start_pt + col_len - 1) * (-1);

af_row = af.row_filter(end:-1:1);
af_col = af.col_filter(end:-1:1);


% analysis operation
% w = d2tconv(v, af_row, row_start_pt, af_col, col_start_pt, 0);
w = d2tconv_fir(v, af_row, row_start_pt, af_col, col_start_pt);
w = d2dwnsmpl(w,2,2,0,0);

w = w*2;

end

