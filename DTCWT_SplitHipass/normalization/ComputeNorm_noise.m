
L=5;
N = 1024; 
sigmaN = 20;
n = sigmaN*randn(N, N);
sigmainit = std(n(:))

[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;

W = DualTree2d(n, L, FS_filter2d, filter2d);

num_hipass = length(filter2d{1}{1})-1;

nor = cell(1,L);
for scale = 1:L
    for part = 1:2
	for dir = 1:2
		for dir1 = 1:num_hipass
    		nor{scale}{part}{dir}{dir1} = std(W{scale}{part}{dir}{dir1}(:))/sigmainit;
		%sqrt(sum(sum(y.^2)))
		end
	end
    end
end

save nor_dualtree_noise nor
