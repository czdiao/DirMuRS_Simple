function [  ] = GenFrames(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nLevel = 2;

% block = [3, 3];
% block_size = block(1)*block(2);

[FS_filter2d, filter2d] = DualTreeFilter2d;

frame = cell(1,2);
for nlevel = 1:2
    frame{nlevel} = cell(1, 3);
    for i = 1:3 %row
        frame{nlevel}{i} = cell(1,3);
        for j = 1:3 %col
            frame{nlevel}{i}{j} = zeros(64,64);
        end
    end
end

for i = 1:64
    for j = 1:64
        inx = zeros(64,64);
        inx(i,j) = 1;
        W = DualTree2d( inx, nLevel, FS_filter2d, filter2d);
        for row = 1:3
           for col = 1:3
               for nlevel = 1:2
                   frame{nlevel}{row}{col}(i,j) = W{nlevel}{1}{1}{1}(row,col);
               end
           end
        end
    end
    fprintf('Finished row %d', i);
end

fprintf('\n');


frame_exact = frame;
save frame_correct frame_exact




end

