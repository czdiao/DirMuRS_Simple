function [W]= unnormcoef(W,L,nor)

for scale = 1:L
    for part = 1:2
	for dir = 1:2
		for dir1 = 1:8
			W{scale}{part}{dir}{dir1} = W{scale}{part}{dir}{dir1}*nor{scale}{part}{dir}{dir1};
		end
	end
    end
end

end