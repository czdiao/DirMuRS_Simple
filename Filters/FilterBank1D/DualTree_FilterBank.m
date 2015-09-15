function [ FS_filter1d, FilterBank1d ] = DualTree_FilterBank
%DUALTREE2D_FB Filter Bank for Dual Tree Complex Wavelet Transform.
%   This is the filter bank claimed in Zhao's paper.
%Output:
%   FS_filter1d:
%       First Stage Filter Banks. Cell array with 2 cells.
%       FS_filter1d{i}: First Stage Filter Bank for Tree i.
%
%   FilterBank1d:
%       Filter Bank for 2 trees. Cell array with 2 cells.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

FS_filter1d = cell(1,2);
FilterBank1d = cell(1,2);

FS_filter1d{1} = FirstStageFilter1d;
FS_filter1d{2} = FirstStageFilterShift1d;
FilterBank1d{1} = Tree1Filter1d;
FilterBank1d{2} = Tree2Filter1d;



end

