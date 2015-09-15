function [ FS_filter1d, FilterBank1d ] = DualTree_FilterBank_test
%DUALTREE_FILTERBANK_TEST
%
%   Chenzhe Diao
%   Sept, 2015

[FS_filter1d, FilterBank1d] = DualTree_FilterBank_Selesnick;

% FS_filter1d{2}(1) = FS_filter1d{1}(1);
% FS_filter1d{2}(1).start_pt = FS_filter1d{1}(1).start_pt - 1;
% FS_filter1d{2}(2) = FS_filter1d{2}(1).CQF;


FS_filter1d{1}(1) = FS_filter1d{2}(1);
FS_filter1d{1}(1).start_pt = FS_filter1d{2}(1).start_pt + 1;
FS_filter1d{1}(2) = FS_filter1d{1}(1).CQF;



end

