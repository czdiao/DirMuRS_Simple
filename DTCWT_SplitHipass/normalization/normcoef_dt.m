function [W]= normcoef_dt(W,L,nor)
%normcoef_dt Normalization of the coefficients of 2d Dual Tree Output
%	Divide the coefficients W by the l2 norm of each filter, so the input Gaussian noise would have unchanged sigma in the coefficients.
%
%   Input:
%	W	:	Wavelet coefficients of Dual Tree Complex Wavelet Coefficients, as output by DualTree2d() function
%	L	:	levels of decompositions
%	nor	:	l2 norm of the filters
%
%   Output:
%	W	:	normalized coefficients

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
