function [ FS_filter2d, filter2d ] = DualTreeFilter2d
%DUALTREEFILTER2D Construct 2D filters for Dual Tree
%   Output in standard 2d Filters structure

% Construct 1d filters
FS_filter1d{1} = FirstStageFilter1d;
FS_filter1d{2} = FirstStageFilterShift1d;
filter1d{1} = Tree1Filter1d;
filter1d{2} = Tree2Filter1d;


% initialization, preallocate the memory
FS_filter2d = cell(1,2);
filter2d = cell(1,2);
% Construct 2d filters
for i = 1:2
    FS_filter2d{i} = cell(1,2);
    filter2d{i} = cell(1,2);
    for j = 1:2
        FS_filter2d{i}{j} = FilterTensorMultiple(FS_filter1d{i}, FS_filter1d{j});
        filter2d{i}{j} = FilterTensorMultiple(filter1d{i}, filter1d{j});
    end
end

% filter2d{i}{j} and FS_filter2d{i}{j}:
%   use tree(i) filters on rows, tree(j) filters on columns 2 construct a 2D
%   filters array. Each array has length 4. The first one is the 2D lowpass.


end

