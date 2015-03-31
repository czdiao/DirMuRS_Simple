function [ f_2d ] = FilterTensor( row_filter, col_filter )
%FILTERTENSOR Use 2 1d filters to generate 2d filter data structure
%   Input:
%           row_filter:     1d filter in row direction
%           col_filter:     1d filter in col direction
%   Output:
%           f_2d:      2d filter

f_2d.row_filter = row_filter.filter;
f_2d.row_start_pt = row_filter.start_pt;
f_2d.col_filter = col_filter.filter;
f_2d.col_start_pt = col_filter.start_pt;


end

