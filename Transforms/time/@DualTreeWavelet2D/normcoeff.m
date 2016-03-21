function W = normcoeff( obj )
%NORMCOEFF Normalization of the coefficients of 2d Dual Tree Output
%	Divide the coefficients W by the l2 norm of each filter, so the input 
%   Gaussian noise would have unchanged sigma in the coefficients.
%
%   Output:
%	W	:	normalized coefficients

W = obj.coeff;
L = obj.nlevel;
nor = obj.nor;

num_hipass=length(W{1}{1}{1});
for scale = 1:L
    for part = 1:2
        for dir = 1:2
            for dir1 = 1:num_hipass
                W{scale}{part}{dir}{dir1} = W{scale}{part}{dir}{dir1}/nor{scale}{part}{dir}{dir1};
            end
        end
    end
end




end

