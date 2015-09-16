function [W]= unnormcoef_dt(W,L,nor)
%unnormcoef_dt  Unnormalized the coefficeint of Dual Tree Complex Wavelet Transform
% 	Inverse of normcoeff_dt()

num_hipass = length(W{1}{1}{1});
for scale = 1:L
    for part = 1:2
	for dir = 1:2
		for dir1 = 1:num_hipass
			W{scale}{part}{dir}{dir1} = W{scale}{part}{dir}{dir1}*nor{scale}{part}{dir}{dir1};
		end
	end
    end
end

end
