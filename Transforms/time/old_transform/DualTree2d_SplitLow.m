function [ w ] = DualTree2d_SplitLow( x, J, FS_filter2d, filterbank2d)
%DualTree2d_SplitLow
%   Split the lowpass filter of the "DualTree2d split highpass" transform.
%   Implemented by post-possessing.
%
%   Input and Output same as DualTree2d()
%
%   u1 and u2 are hard-coded here.


w = DualTree2d( x, J, FS_filter2d, filterbank2d);

% u1_filter = [-0.5, 0.5];
% u1_start_pt = -1;
% 
% u2_filter = [-0.5, -0.5];
% u2_start_pt = -2;

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
    for rowtree = 1:2
        for coltree = 1:2
            % Split row: band 1, 2; Split col: band 3, 6
            tmp1 = PostSplit2d(w{j}{rowtree}{coltree}{1},u1, 1);
            tmp2 = PostSplit2d(w{j}{rowtree}{coltree}{1},u2, 1);
            w{j}{rowtree}{coltree}{1} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 2);
            
            tmp1 = PostSplit2d(w{j}{rowtree}{coltree}{3},u1, 1);
            tmp2 = PostSplit2d(w{j}{rowtree}{coltree}{3},u2, 1);
            w{j}{rowtree}{coltree}{3} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 4);
            
            tmp1 = PostSplit2d(w{j}{rowtree}{coltree}{5},u1, 2);
            tmp2 = PostSplit2d(w{j}{rowtree}{coltree}{5},u2, 2);
            w{j}{rowtree}{coltree}{5} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 6);
            
            tmp1 = PostSplit2d(w{j}{rowtree}{coltree}{9},u1, 2);
            tmp2 = PostSplit2d(w{j}{rowtree}{coltree}{9},u2, 2);
            w{j}{rowtree}{coltree}{9} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 10);
        end
    end
end




end

