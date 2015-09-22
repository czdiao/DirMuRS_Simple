function [ FS_filter1d, FilterBank1d ] = DualTree_FilterBank_Selesnick(shift_method)
%DUALTREE_FILTERBANK_SELESNICK
% This is exactly the same filter bank used in Selesnick's onle code
% 
% A little bit different from the filter bank claimed in Zhao's paper.
% As the original 4 functions implemented:
%       FirstStageFilter1d, FirstStageFilterShift1d
%       Tree1Filter1d, Tree2Filter1d
% are the filter banks claimed on Zhao's paper.
%
%Input:
%   shift_method:
%       Choose between 'shift', 'flip'. Default is 'flip', as Selesnick's
%       original code.
%
% NOTE: 
%   In this implementation, tree1 is the imaginary part, tree2 is the real
%   part.
%
%   Chenzhe Diao

if nargin<1
    shift_method = 'flip';
end


FS_filter1d = cell(1,2);
FilterBank1d = cell(1,2);

FilterBank1d{1} = Tree2Filter1d;
FilterBank1d{2} = Tree1Filter1d;

FS_filter1d{2} = FirstStageFilter1d;
FS_filter1d{2}(1).start_pt = -2;
FS_filter1d{2}(2) = FS_filter1d{2}(1).CQF;


switch shift_method
    case('flip')
        % Method 1, conjflip
        FS_filter1d{1}(1) = FS_filter1d{2}(1).conjflip;
        FS_filter1d{1}(1).start_pt = -3;
        FS_filter1d{1}(2) = FS_filter1d{1}(1).CQF;
    case('shift')
        % Method 2, shift by one
        FS_filter1d{1}(1) = FS_filter1d{2}(1);
        FS_filter1d{1}(1).start_pt = FS_filter1d{1}(1).start_pt + 1;
        FS_filter1d{1}(2) = FS_filter1d{1}(1).CQF;
    otherwise
        error('Wrong input!');
end





end

