%% Struct for 2d tensor product filter
%   filter2d:
%       filter2d.row_filter:    array of row filter
%       filter2d.col_filter:    array of col filter
%       filter2d.row_start_pt:  row filter array starting point
%       filter2d.col_start_pt:  col filter array starting point
%   filter1d:
%       filter1d.filter:    array of filter
%       filter1d.start_pt:  filter array starting point


clear; clc;

%% test for PR

% lo.filter = [1+sqrt(3), 3+sqrt(3), 3-sqrt(3), 1-sqrt(3)]/8;
% lo.start_pt = -1;
% hi.filter = [1-sqrt(3), sqrt(3)-3, 3+sqrt(3), -1-sqrt(3)]/8;
% hi.start_pt = -1;

% x = rand(20, 20);
% %x(1,1) = 1;
% [lo, hi] = Tree2Filter;
% %hi.filter = hi.filter*(-1);
% 
% 
% 
% filter(1) = FilterTensor(lo, lo);
% filter(2) = FilterTensor(lo, hi);
% filter(3) = FilterTensor(hi, lo);
% filter(4) = FilterTensor(hi, hi);
% 
% w = cell(4,1);
% for i = 1:4
%     %w{i} = zeros(10,10);
%     w{i} = analysis2d(x, filter(i));
% end
% 
% y = synthesis2d(w, filter);
% err = max(max(abs(x-y)))

% normy = Matrix2SqNorm(y);
% normw = Matrix2SqNorm(w{1});
 
% s = 0;
% t = Matrix2SqNorm(y);
% for i = 1:4
%     s = s + Matrix2SqNorm(w{i});
% end
% err_n = abs(s-t)

% x = 100*rand(6, 6);
% x(1, 1) = 1;
% 
% u = [1, 1, 3, 4, 7];
% v = [5, 2];
% 
% w = d2tconv(x, u, 0, v, 0, 0);
% w1 = d2tconv_new(x, u, 0, v, 0);
% err = max(max(abs(x-w)))


% imgName    = 'pics/Lena512.png';
% x = double(imread(imgName));

x = rand(1024, 1024);

% [FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
[FS_filter2d, filter2d] = DualTreeFilter2d;

w = DualTree2d(x, 5, FS_filter2d, filter2d);
y = iDualTree2d(w,5, FS_filter2d, filter2d);
err = max(max(abs(x-y)))


% [lo, hi] = Haar1d
% 
% f = convfilter1d(lo, hi)

% x = rand(1000);
% 
% u = [1, 0, 3];
% v = [2, 5];

% for i = 1:100
%     y1 = d2tconv(x, v, -3, u, 2, 0);
%     y2 = d2tconv_fir(x, v, -3, u, 2);
% end
% err = max(max(abs(y1-y2)))


% load('nor_dualtree_noise.mat')
% 
% 
% a = zeros(5, 8);
% for i = 1:5
%     for j = 1:8
%         a(i,j) = nor{i}{1}{1}{j};
%     end
% end



% load('nor_dualtree_noise.mat')
% 
% for i=1:5
%     for tree1=1:1
%         for tree2=1:1
%             fprintf('level=%d, t1=%d, t2=%d:\n', i, tree1, tree2);
%             n = cell2mat(nor{i}{tree1}{tree2})
%        end
%     end
% end
% 
% 


















