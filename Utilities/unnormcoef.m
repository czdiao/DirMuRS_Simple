function [W]= unnormcoef(W,L,nor)
% Unnormalize the coefficients. Used in shrinkage denoising.

for scale = 1:L
    num_hipass = length(W{scale});
    for dir1 = 1:num_hipass
        W{scale}{dir1} = W{scale}{dir1}*nor{scale}{dir1};
    end
end

end
