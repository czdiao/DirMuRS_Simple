function [ FS_filter1d, FilterBank1d ] = DualTree_FilterBank_freq_cpt( N )
%DUALTREE_FILTERBANK_FREQ_CPT Frequency Based Filter Banks for Dual Tree CWT.
%   The Filters are still time-limited, same filters as in time domain.
%   This function is just for testing purpose.
%
%Input:
%   N:  length of the frequency based filter.
%
%Output:
%   FS_filter1d:
%       First Stage Frequency Based Filter Banks. Cell array with 2 cells.
%       FS_filter1d{i}: First Stage Frequency Based Filter Bank for Tree i.
%
%   FilterBank1d:
%       Frequency Based Filter Bank for 2 trees. Cell array with 2 cells.
%
%   Author: Chenzhe Diao
%   Date:   July, 2015



% [FS_filter1d, FilterBank1d] = DualTree_FilterBank;
[FS_filter1d, FilterBank1d] = DualTree_FilterBank_Selesnick;

for i = 1:2
    FS_filter1d{i} = convert_ffilter(FS_filter1d{i},N);
    FilterBank1d{i} = convert_ffilter(FilterBank1d{i}, N);
end



end

