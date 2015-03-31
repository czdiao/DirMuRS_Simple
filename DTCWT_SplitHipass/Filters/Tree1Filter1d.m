function [ filter ] = Tree1Filter1d
%TREE1FILTER1D Dual Tree Filter of Tree 1 by Selesnick
%   Output in standard data structure of 1D filter bank

lo.filter = [0.03516384, 0, -0.08832942, 0.23389032, 0.76027237, 0.5875183, 0, -0.11430184]/sqrt(2);
lo.start_pt = -4;

hi = CQF(lo);

filter = [lo, hi];


end

