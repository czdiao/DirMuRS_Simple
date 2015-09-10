function [ FS_filter1d, FilterBank1d ] = DualTree_FilterBank_Selesnick
%DUALTREE_FILTERBANK_SELESNICK Summary of this function goes here
%   Detailed explanation goes here

FS_filter1d = cell(1,2);
FilterBank1d = cell(1,2);

FS_filter1d{1} = FirstStageFilter1d;

FS_filter1d{1}(1).filter = FS_filter1d{1}(1).filter(end:-1:1);
FS_filter1d{1}(2) = FS_filter1d{1}(1).CQF;

FS_filter1d{2}(1) = FS_filter1d{1}(1).conjflip;
FS_filter1d{2}(1).start_pt = -2;
FS_filter1d{2}(2) = FS_filter1d{2}(1).CQF;
% FS_filter1d{2}(2) = FS_filter1d{1}(2).conjflip;




FilterBank1d{1} = Tree1Filter1d;
FilterBank1d{2} = Tree2Filter1d;

FilterBank1d{1}(1).filter = FilterBank1d{1}(1).filter(end:-1:1);
FilterBank1d{1}(1).start_pt = -2;   %-3
FilterBank1d{1}(2) = FilterBank1d{1}(1).CQF;
FilterBank1d{2}(1).filter = FilterBank1d{2}(1).filter(end:-1:1);
FilterBank1d{2}(1).start_pt = -4;   %-3
FilterBank1d{2}(2) = FilterBank1d{2}(1).CQF;



end

