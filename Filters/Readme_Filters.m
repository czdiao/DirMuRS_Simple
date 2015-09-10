%% Filters
% _*Author: Chenzhe Diao*_
% 
% Implementation of 1D and 2D separable filters.
% Haar, Daubechies8 and Dual Tree Filters. Some help functions for
% constructing filters.
%


%% Class of 1D/2D filters:   filter1d filter2d
% 
% * *1D Filter class : <matlab:edit('filter1d.m') filter1d.m>* 
%
%       Properties:
%           filter  :   1d vector, filter array.
%           start_pt:   integer, starting point position of the filter.
%           label   :   char array. To label 'low', 'hi', etc. (Optional)
%
%       Methods:
%           filter1d:   Constructor. Could be called as:
%                           1) f = filter1d(vec, pt, label)
%                           2) f = filter1d(vec, pt)
%                           3) f = filter1d
%           CQF     :   Generate highpass from lowpass by CQF pairs. $b_n=(-1)^(n+1)a_{1-n}$
%                           1) hi = CQF(low)
%                           2) hi = low.CQF
%                       where low and hi are both filter1d objects.
%           convfilter: Convolution of 2 1d filters.
%                           1) f = convfilter(u, v)
%                           2) f = u.convfilter(v)
%                       where u, v, f are all filter1d objects.
%
% * *2D Filter class : <matlab:edit('filter2d.m') filter2d.m>* 
%
%       Properties:
%           row_filter  :   1d vector
%           col_filter  :   1d vector
%
%           row_start_pt:   integer, starting point position of row filter.
%           col_start_pt:   integer, starting point position of col filter.
%
%           row_label   :   char array. To label 'low', 'hi', etc. (Optional)
%           col_label   :   char array. To label 'low', 'hi', etc. (Optional)
%
%       Methods:
%           filter2d:   Constructor. Could be called as:
%                           1) f = filte2d(f1d_row, f1d_col)
%                           2) f = filter2d
%                       where f1d_row and f1d_col are both filter1d objects, f is a filter2d object.

%% Data Structure of 1D/2D filter banks
% * *1D Filter Bank: array of filter1d objects.*
% * *2D Filter Bank: array of filter2d objects.*
% * *<matlab:edit('FilterBankTensor.m') FilterBankTensor.m>: Construct 2D Filter Bank by two 1D Filter Banks for each dimension.*
%
% *_Notice that we always put lowpass filter at the first place in filter banks:_* 
% [lowpass, highpass1, highpass2, ...]. 

% Example of 1D filter bank
HaarFilterBank = Haar1d         % Construct Haar Filter Bank
Lowpass = HaarFilterBank(1)     % Lowpass filter
Highpass = HaarFilterBank(2)    % Highpass filter

%%

% Example of 2D filter bank
Haar2d = FilterBankTensor(HaarFilterBank, HaarFilterBank)   % Construct 2D Haar Filter Bank
LL = Haar2d(1)
LH = Haar2d(2)
HL = Haar2d(3)
HH = Haar2d(4)

%% Implementation of 1D filter banks
% 
% * <matlab:edit('Haar1d.m') Haar1d.m>
% * <matlab:edit('Daubechies8_1d.m') Daubechies8_1d.m>
% * <matlab:edit('FirstStageFilter1d.m') FirstStageFilter1d.m>
% * <matlab:edit('FirstStageFilterShift1d.m') FirstStageFilterShift1d.m>
% * <matlab:edit('Tree1Filter1d.m') Tree1Filter1d.m>
% * <matlab:edit('Tree2Filter1d.m') Tree2Filter1d.m>

HaarFB = Haar1d;                    % Haar Filter Bank
D8FB = Daubechies8_1d;              % Daubechies 8 Filer Bank

FSFB = FirstStageFilter1d;          % Dual Tree Fist Stage Filter Bank a_0
FS2FB = FirstStageFilterShift1d;    % Dual Tree First Stage Shift Filter Bank for Tree2
DT1FB = Tree1Filter1d;              % Dual Tree Filter Bank for Tree 1
DT2FT = Tree2Filter1d;              % Dual Tree Filter Bank for Tree 2
%% Implementation of 2D filter banks
% 
% * <matlab:edit('Daubechies8_2d.m') Daubechies8_2d.m>
D8FB_2d = Daubechies8_2d;           % 2D Daubechies 8 Filter Bank
%%
% _*2D Dual Tree Filter Banks*_
%
% * <matlab:edit('DualTreeFilter2d.m') DualTreeFilter2d.m>
% * <matlab:edit('DualTreeFilter2d_SplitHipass.m') DualTreeFilter2d_SplitHipass.m>

% Output: 
%   First Stage Filter Banks:   FS_FB{row_tree}{col_tree}{band}
%   Later Stage Filter Banks:   FB{row_tree}{col_tree}{band}
%   row_tree, col_tree = 1, 2
[FS_FB, FB] = DualTreeFilter2d;             % band = 1 : 3
[FS_FB, FB] = DualTreeFilter2d_SplitHipass  % band = 1 : 8










