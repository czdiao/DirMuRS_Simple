function [ y ] = iDualTree2d_SplitHighLow( w, J, FS_fb1d, fb1d, u_hi, u_low )
%IDUALTREE2D_SPLITHIGHLOW Summary of this function goes here
%   Detailed explanation goes here

%% old implementation
% u1_filter = [-0.60681876962335599886786626353146e0 -0.49991154192621583718062920651918e0 0.10690722769714197302003653746564e0];
% u1_start_pt = -1;
% u2_filter = [-0.25470239962557002238379596440787e0 0.49059520074885961634677871315419e0 -0.25470239962557036126943406144510e0];
% u2_start_pt = -1;
% 
% u1 = filter1d(u1_filter, u1_start_pt);
% u2 = filter1d(u2_filter, u2_start_pt);
% 
% 
% for j = 1:J
%     for m = 1:2
%         for n = 1:2
%             w{j}{m}{n}{1} = PostCombine(w{j}{m}{n}{1}, u1, w{j}{m}{n}{2}, u2, 1);
%             w{j}{m}{n} = DeleteCell(w{j}{m}{n}, 2);
%             
%             w{j}{m}{n}{2} = PostCombine(w{j}{m}{n}{2}, u1, w{j}{m}{n}{3}, u2, 1);
%             w{j}{m}{n} = DeleteCell(w{j}{m}{n}, 3);
%             
%             w{j}{m}{n}{3} = PostCombine(w{j}{m}{n}{3}, u1, w{j}{m}{n}{4}, u2, 2);
%             w{j}{m}{n} = DeleteCell(w{j}{m}{n}, 4);
%             
%             w{j}{m}{n}{4} = PostCombine(w{j}{m}{n}{4}, u1, w{j}{m}{n}{5}, u2, 2);
%             w{j}{m}{n} = DeleteCell(w{j}{m}{n}, 5);
%         end
%     end
% end
% 
% 
% y = iDualTree2d_SplitHigh(w, J, FS_fb1d, fb1d);


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


for j = 1:J
    for m = 1:12
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end

y = zeros(size(w{1}{1}{1}{1})*2);

for m = 1:2
    for n = 1:2
        
        LL = w{J+1}{n}{m};
        for j = J:(-1):2
            w{j}{n}{m} = CombineHiLow1(w{j}{n}{m}, u1_low, u2_low, u1_hi, u2_hi);
            coeff = [LL, w{j}{n}{m}];
            LL = d2tsynthesis(coeff, 2, fb1d{n},fb1d{m});
        end
        w{1}{n}{m} = CombineHiLow1(w{1}{n}{m}, u1_low, u2_low, u1_hi, u2_hi);
        coeff = [LL, w{1}{n}{m}];
        LL = d2tsynthesis(coeff, 2, FS_fb1d{n}, FS_fb1d{m});
        y = y + LL;
    end
end

y = y/4;

y = y*2;    % Normalized to be tight frames




end

function w_new = CombineHiLow1(w, u1_low, u2_low, u1_hi, u2_hi)
%% Combine each band in one level.

w_new = cell(1,3);


tmp1 = PostCombine(w{1}, u1_low, w{2}, u2_low, 1);
tmp2 = PostCombine(w{3}, u1_low, w{4}, u2_low, 1);
w_new{1} = PostCombine(tmp1, u1_hi, tmp2, u2_hi, 2);

tmp1 = PostCombine(w{5}, u1_low, w{6}, u2_low, 2);
tmp2 = PostCombine(w{7}, u1_low, w{8}, u2_low, 2);
w_new{2} = PostCombine(tmp1, u1_hi, tmp2, u2_hi, 1);

tmp1 = PostCombine(w{9}, u1_hi, w{10}, u2_hi, 2);
tmp2 = PostCombine(w{11}, u1_hi, w{12}, u2_hi, 2);

w_new{3} = PostCombine(tmp1, u1_hi, tmp2, u2_hi, 1);


end




