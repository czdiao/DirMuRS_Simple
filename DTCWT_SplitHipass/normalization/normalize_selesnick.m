

N = 2^10; 
L = 5;
x = zeros(N,N);

[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;

W_zero = DualTree2d(x, L, FS_filter2d, filter2d);

nor = cell(1,L);

num_hipass = length(filter2d{1}{1})-1;

parfor scale = 1:L
    no = 1;
    for tree1 = 1:2
	for tree2 = 1:2
		for hipass = 1:num_hipass
    		W = W_zero; 
    		W{scale}{tree1}{tree2}{hipass}(no,no) = 1;
            y = iDualTree2d(W, L, FS_filter2d, filter2d);
            nor{scale}{tree1}{tree2}{hipass} = sqrt(sum(sum(y.^2)));
		end
	end
    end
end

save nor_selesnick nor

