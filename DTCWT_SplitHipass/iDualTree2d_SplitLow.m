function [ y ] = iDualTree2d_SplitLow( w, J, FS_filter2d, filter2d)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

u1.filter = [-0.5, 0.5];
u1.start_pt = -1;

u2.filter = [-0.5, -0.5];
u2.start_pt = -2;

for j = 1:J
    for row = 1:2
        for col = 1:2
            w{j}{row}{col}{1} = CombineFilter2d(w{j}{row}{col}{1}, u1, w{j}{row}{col}{2}, u2, 1);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 2);
            
            w{j}{row}{col}{2} = CombineFilter2d(w{j}{row}{col}{2}, u1, w{j}{row}{col}{3}, u2, 1);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 3);
            
            w{j}{row}{col}{3} = CombineFilter2d(w{j}{row}{col}{3}, u1, w{j}{row}{col}{4}, u2, 2);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 4);
            
            w{j}{row}{col}{6} = CombineFilter2d(w{j}{row}{col}{6}, u1, w{j}{row}{col}{7}, u2, 2);
            w{j}{row}{col} = DeleteCell(w{j}{row}{col}, 7);
        end
    end
end

y = iDualTree2d( w, J, FS_filter2d, filter2d);



end

