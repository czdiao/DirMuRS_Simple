%% Struct for 2d tensor product filter
%   filter2d:
%       filter2d.row_filter:    array of row filter
%       filter2d.col_filter:    array of col filter
%       filter2d.row_start_pt:  row filter array starting point
%       filter2d.col_start_pt:  col filter array starting point
%   filter1d:
%       filter1d.filter:    array of filter
%       filter1d.start_pt:  filter array starting point


% clear; clc;

%% test for PR
% imgName    = 'pics/Lena512.png';
% x = double(imread(imgName));

x = rand(1024, 1024);

[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
% % [FS_filter2d, filter2d] = DualTreeFilter2d;
% 
w = Framelet2d(x, 5, FS_filter2d{1}{2}, filter2d{2}{1});
y = iFramelet2d(w, 5, FS_filter2d{1}{2}, filter2d{2}{1});
% w = DualTree2d(x, 5, FS_filter2d, filter2d);
% y = iDualTree2d(w,5, FS_filter2d, filter2d);
err = max(max(abs(x-y)))




%%


% load('nor_dualtree_noise.mat')
% load('nor_selesnick_Q1Haar.mat')

% load('nor_dualtree_noise.mat');
% nor_noise = nor;
% load('nor_selesnick_OrigHaar.mat');
% nor_selesnick = nor;
% 
% for i=5:5
%     for tree1=1:1
%         for tree2=1:1
%             fprintf('level=%d, t1=%d, t2=%d:\n', i, tree1, tree2);
%             n_noise = cell2mat(nor_noise{i}{tree1}{tree2})
%             n_selesnick = cell2mat(nor_selesnick{i}{tree1}{tree2})
%        end
%     end
% end
% 
% n_noise./n_selesnick

% [FS_filter2d, filter2d] = DualTreeFilter2d;

% filter_norm = zeros(1,3);
% for i = 1:3
%     filter_norm(i) = sqrt(Filter2SqNorm(FS_filter2d{1}{1}(i+1)));
% end
% filter_norm


%%
% tmp = zeros(1,7);
% isklen = length(PSNR_matrix(:,1,1));
% ittlen = length(PSNR_matrix(1,:,1));
% 
% err = zeros(isklen, ittlen);
% 
% comp = [37.84, 34.18, 29.35, 26.86, 25.71, 23.53, 22.64];
% 
% for isk=1:length(PSNR_matrix(:,1,1))
%     for itt = 1:length(PSNR_matrix(1,:,1))
%         for i = 1:7
%             tmp(i) = PSNR_matrix(isk, itt, i);
%         end
%         err(isk, itt) = max(comp - tmp);
%     end
% end
% 
% min(min(err))




