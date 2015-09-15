function [ FS_filter2d, FilterBank2d ] = DualTreeFilter2d_SplitHipass_old
%DUALTREEFILTER2D_SPLITHIPASS Construct 2D Filter Bank for Dual Tree Split
%Highpass

% Construct 1d dual-tree filters
FS_filter1d{1} = FirstStageFilter1d;
FS_filter1d{2} = FirstStageFilterShift1d;
FilterBank1d{1} = Tree1Filter1d;
FilterBank1d{2} = Tree2Filter1d;

% Split Hipass
u1_start_pt = -2;
u1_filter = [-0.5, 0, 0.5];
u2_start_pt = -2;   % -4
u2_filter = [-0.5, 0, -0.5];

u1 = filter1d(u1_filter, u1_start_pt);
u2 = filter1d(u2_filter, u2_start_pt);

% u1coeff = [-0.13596253880164942012651595042663e0,...
%     0,...
%     -0.19969163254816203381664971230051e0,...
%     0,...
%     0.51187821898193219827418789397416e0,...
%     0,...
%     -0.41297719636057624742364278474580e0];
% 
% u2coeff = [-0.14000012696680652874793807797051e0,...
%     0,...
%     0.16005164328038426763317084902142e0,...
%     0,...
%     0.55045134013263479577827327835729e0,...
%     0,...
%     0.40106697972984013787343526166126e0];
% u1.filter = u1coeff(end:-1:1);
% u1.start_pt = -4;
% u2.filter = u2coeff;
% u2.start_pt = -4;


for i = 1:2
    split1 = convfilter(FS_filter1d{i}(2), u1);
    split2 = convfilter(FS_filter1d{i}(2), u2);
%     FS_filter1d{i}(2) = [];
    FS_filter1d{i} = [FS_filter1d{i}(1), split1, split2];
    
    split1 = convfilter(FilterBank1d{i}(2), u1);
    split2 = convfilter(FilterBank1d{i}(2), u2);
%     FilterBank1d{i}(2) = [];
    FilterBank1d{i} = [FilterBank1d{i}(1), split1, split2];
end

% initialization, preallocate the memory
FS_filter2d = cell(1,2);
FilterBank2d = cell(1,2);
% Construct 2d filters
for i = 1:2
    FS_filter2d{i} = cell(1,2);
    FilterBank2d{i} = cell(1,2);
    for j = 1:2
        FS_filter2d{i}{j} = FilterBankTensor(FS_filter1d{i}, FS_filter1d{j});
        FilterBank2d{i}{j} = FilterBankTensor(FilterBank1d{i}, FilterBank1d{j});
    end
end



end

