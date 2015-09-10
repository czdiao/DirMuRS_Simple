%% Compute the norm of filters(DAS) in each level, each band.
%   Generate the filter by reconstruction

clear;

L = 5;
p = 64;
nor = cell(1,L);


[FS_filter1d, fb1d] = DualTree_FilterBank_freq(1024);

% [FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
% [FS_filter2d, filter2d] = DualTreeFilter2d;
% filter = Daubechies8Filter2d;
% [FS_filter1d, fb1d] = DualTree_FilterBank_Selesnick;
% fb = Daubechies8_1d;


% W_zero = fDualTree2d_SplitHighLow(x, L, FS_filter1d, fb1d);
% W_zero = Framelet2d_new(x,L,fb);


% num_hipass = length(W_zero{1});

no = 1;

for scale = 1:1%L
    N = p*2^scale; 
    x = zeros(N,N);
    W_zero = fDualTree2d_SplitHighLow(x, scale, FS_filter1d, fb1d);
    num_hipass = length(W_zero{1}{1}{1});

    for tree1 = 1:2
        for tree2 = 1:2
            for hipass = 1:num_hipass
                W = W_zero;
                W{scale}{tree1}{tree2}{hipass}(no,no) = 1;
                y = ifDualTree2d_SplitHighLow(W, scale, FS_filter1d, fb1d);
%                 y = iDualTree2d_SplitHighLow(W, scale, FS_filter1d, fb1d);
                nor{scale}{tree1}{tree2}{hipass} = sqrt(sum(sum(abs(y).^2)));
            end
        end
    end
    fprintf('Level = %d\n', scale);
end

nor{1}{1}{1}(:)

% for scale = 1:L
%     no = floor(size(W_zero{scale}{1},1)/2);
%     for hipass = 1:num_hipass
%         W = W_zero;
%         W{scale}{hipass}(no,no) = 1;
%         y = iFramelet2d_new(W, L, fb);
%         nor{scale}{hipass} = sqrt(sum(sum(y.^2)));
%     end
% end

% save nor_DT_SplitTime nor
% save nor_daubechies8 nor

