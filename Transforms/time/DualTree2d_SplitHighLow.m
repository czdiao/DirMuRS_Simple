function [ w ] = DualTree2d_SplitHighLow( x, J, FS_fb1d, fb1d, u_hi, u_low )
%DUALTREE2D_SPLITHIGHLOW Summary of this function goes here
%   Detailed explanation goes here

%% old implementation
% w = DualTree2d_SplitHigh(x, J, FS_fb1d, fb1d);
% 
% u1_filter = [-0.60681876962335599886786626353146e0 -0.49991154192621583718062920651918e0 0.10690722769714197302003653746564e0];
% u1_start_pt = -1;
% u2_filter = [-0.25470239962557002238379596440787e0 0.49059520074885961634677871315419e0 -0.25470239962557036126943406144510e0];
% u2_start_pt = -1;
% 
% u1 = filter1d(u1_filter, u1_start_pt);
% u2 = filter1d(u2_filter, u2_start_pt);
% 
% for j = 1:J
%     for m = 1:2
%         for n = 1:2
%             
%             tmp1 = PostSplit(w{j}{m}{n}{1},u1, 1);
%             tmp2 = PostSplit(w{j}{m}{n}{1},u2, 1);
%             w{j}{m}{n}{1} = tmp1;
%             w{j}{m}{n} = InsertCell(w{j}{m}{n}, tmp2, 2);
%             
%             tmp1 = PostSplit(w{j}{m}{n}{3},u1, 1);
%             tmp2 = PostSplit(w{j}{m}{n}{3},u2, 1);
%             w{j}{m}{n}{3} = tmp1;
%             w{j}{m}{n} = InsertCell(w{j}{m}{n}, tmp2, 4);
%             
%             tmp1 = PostSplit(w{j}{m}{n}{5},u1, 2);
%             tmp2 = PostSplit(w{j}{m}{n}{5},u2, 2);
%             w{j}{m}{n}{5} = tmp1;
%             w{j}{m}{n} = InsertCell(w{j}{m}{n}, tmp2, 6);
%             
%             tmp1 = PostSplit(w{j}{m}{n}{7},u1, 2);
%             tmp2 = PostSplit(w{j}{m}{n}{7},u2, 2);
%             w{j}{m}{n}{7} = tmp1;
%             w{j}{m}{n} = InsertCell(w{j}{m}{n}, tmp2, 8);
%         end
%     end
% end

%% new implementation

% u1_filter = [-0.60681876962335599886786626353146e0 -0.49991154192621583718062920651918e0 0.10690722769714197302003653746564e0];
% u1_start_pt = -1;
% u2_filter = [-0.25470239962557002238379596440787e0 0.49059520074885961634677871315419e0 -0.25470239962557036126943406144510e0];
% u2_start_pt = -1;
% 
% u1_low = filter1d(u1_filter, u1_start_pt);
% u2_low = filter1d(u2_filter, u2_start_pt);
% 
% u1_hi = filter1d([-0.5, 0.5],-1);
% u2_hi = filter1d([-0.5, -0.5], -1);


% filters to split the high pass filters
u1_hi = u_hi(1);
u2_hi = u_hi(2);

% filters to split the low pass filters
u1_low = u_low(1);
u2_low = u_low(2);

w = cell(1, J+1);
x = x/2;   % to normalize to tight frame


%Initialize memory
for j = 1:J+1
    w{j} = cell(1,2);
    for k = 1:2
        w{j}{k} = cell(1,2);
    end
end

for rowtree = 1:2
    for coltree = 1:2
        
        % First Stage
        [L, H] = d2tanalysis(x, 2, FS_fb1d{coltree}, FS_fb1d{rowtree});
        w{1}{coltree}{rowtree} = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi);
        
        % Later Stages
        for j = 2:J
            [L, H] = d2tanalysis(L, 2, fb1d{coltree}, fb1d{rowtree});
            w{j}{coltree}{rowtree} = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi);
        end
        w{J+1}{coltree}{rowtree} = L;
        
    end
end


for j = 1:J
    for m = 1:12
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end





end


function w = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi)
%% Split Hipass and Lowpass
%H{3} : {LH}, {HL}, {HH}

w = cell(1,12);

% Split Hipass
tmp1 = PostSplit(H{1},u1_hi, 2);
tmp2 = PostSplit(H{1},u2_hi, 2);
% Split Lowpass
w{1} = PostSplit(tmp1,u1_low, 1);
w{2} = PostSplit(tmp1,u2_low, 1);
w{3} = PostSplit(tmp2,u1_low, 1);
w{4} = PostSplit(tmp2,u2_low, 1);

% Split Hipass
tmp1 = PostSplit(H{2},u1_hi, 1);
tmp2 = PostSplit(H{2},u2_hi, 1);
% Split Lowpass
w{5} = PostSplit(tmp1,u1_low, 2);
w{6} = PostSplit(tmp1,u2_low, 2);
w{7} = PostSplit(tmp2,u1_low, 2);
w{8} = PostSplit(tmp2,u2_low, 2);

% Split HH
tmp1 = PostSplit(H{3},u1_hi, 1);
tmp2 = PostSplit(H{3},u2_hi, 1);
w{9}  = PostSplit(tmp1,u1_hi, 2);
w{10} = PostSplit(tmp1,u2_hi, 2);
w{11} = PostSplit(tmp2,u1_hi, 2);
w{12} = PostSplit(tmp2,u2_hi, 2);

end

