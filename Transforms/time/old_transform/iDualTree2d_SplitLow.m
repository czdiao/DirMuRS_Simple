function [ y ] = iDualTree2d_SplitLow( w, J, FS_filter2d, filter2d)
%iDualTree2d_SplitLow
%   Inverse of the Split Lowpass and Highpass of DualTree2d transform.
%   Inverse of DualTree2d_SplitLow() function.
%
%   Input and Output same as iDualTree2d()
%
%   u1 and u2 are hard-coded here.



% u1.filter = [-0.5, 0.5];
% u1.start_pt = -1;
% 
% u2.filter = [-0.5, -0.5];
% u2.start_pt = -2;

u1_filter = [-0.60681876962335599886786626353146e0 -0.49991154192621583718062920651918e0 0.10690722769714197302003653746564e0];
u1_start_pt = -1;
u2_filter = [-0.25470239962557002238379596440787e0 0.49059520074885961634677871315419e0 -0.25470239962557036126943406144510e0];
u2_start_pt = -1;

% u1.filter = zeros(1, 3);
% u2.filter = zeros(1, 3);
% u1.filter(1) = -sin(t3)*cos(t2)*sin(t1);
% u1.filter(2) = -cos(t3)*sin(t2)*sin(t1) - sin(t3)*sin(t2)*cos(t1);
% u1.filter(3) =  cos(t3)*cos(t2)*cos(t1);
% u2.filter(1) = -sin(t3)*cos(t2)*cos(t1);
% u2.filter(2) = -cos(t3)*sin(t2)*cos(t1) + sin(t3)*sin(t2)*sin(t1);
% u2.filter(3) = -cos(t3)*cos(t2)*sin(t1);

u1 = filter1d(u1_filter, u1_start_pt);
u2 = filter1d(u2_filter, u2_start_pt);

for j = 1:J
    for row = 1:2
        for col = 1:2
            w{j}{row}{col}{1} = PostCombine2d(w{j}{row}{col}{1}, u1, w{j}{row}{col}{2}, u2, 1);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 2);
            
            w{j}{row}{col}{2} = PostCombine2d(w{j}{row}{col}{2}, u1, w{j}{row}{col}{3}, u2, 1);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 3);
            
            w{j}{row}{col}{3} = PostCombine2d(w{j}{row}{col}{3}, u1, w{j}{row}{col}{4}, u2, 2);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 4);
            
            w{j}{row}{col}{6} = PostCombine2d(w{j}{row}{col}{6}, u1, w{j}{row}{col}{7}, u2, 2);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 7);
        end
    end
end

y = iDualTree2d( w, J, FS_filter2d, filter2d);



end

