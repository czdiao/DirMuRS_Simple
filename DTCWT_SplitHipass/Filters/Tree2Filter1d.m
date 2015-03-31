function [ filter ] = Tree2Filter1d
%TREE2FILTER1D Dual Tree Filter of Tree 2 by Selesnick
%   Output in standard data structure of 1D filter bank

tree1filter = [0.03516384, 0, -0.08832942, 0.23389032, 0.76027237, 0.5875183, 0, -0.11430184]/sqrt(2);
lo.filter = tree1filter(end:-1:1);

lo.start_pt = -2;

hi = CQF(lo);

filter = [lo, hi];

end

