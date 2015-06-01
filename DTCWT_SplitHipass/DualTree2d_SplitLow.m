function [ w ] = DualTree2d_SplitLow( x, J, FS_filter2d, filter2d)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


w = DualTree2d( x, J, FS_filter2d, filter2d);

u1.filter = [-0.5, 0.5];
u1.start_pt = -1;

u2.filter = [-0.5, -0.5];
u2.start_pt = -2;

for j = 1:J
    for rowtree = 1:2
        for coltree = 1:2
            % Split row: band 1, 2; Split col: band 3, 6
            tmp1 = SplitFilter2d(w{j}{rowtree}{coltree}{1},u1, 1);
            tmp2 = SplitFilter2d(w{j}{rowtree}{coltree}{1},u2, 1);
            w{j}{rowtree}{coltree}{1} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 2);
            
            tmp1 = SplitFilter2d(w{j}{rowtree}{coltree}{3},u1, 1);
            tmp2 = SplitFilter2d(w{j}{rowtree}{coltree}{3},u2, 1);
            w{j}{rowtree}{coltree}{3} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 4);
            
            tmp1 = SplitFilter2d(w{j}{rowtree}{coltree}{5},u1, 2);
            tmp2 = SplitFilter2d(w{j}{rowtree}{coltree}{5},u2, 2);
            w{j}{rowtree}{coltree}{5} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 6);
            
            tmp1 = SplitFilter2d(w{j}{rowtree}{coltree}{9},u1, 2);
            tmp2 = SplitFilter2d(w{j}{rowtree}{coltree}{9},u2, 2);
            w{j}{rowtree}{coltree}{9} = tmp1;
            w{j}{rowtree}{coltree} = InsertCell(w{j}{rowtree}{coltree}, tmp2, 10);
        end
    end
end




end

