function [row, col] = ij_index(count, block)
    row = ceil(count/block(2));
    col = count - (row-1) * block(2);
end
