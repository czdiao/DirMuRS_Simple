function [ y ] = iDualTree2d( w, J, FS_fb1d, fb1d )
%IDUALTREE2D Inverse Complex Dual Tree Wavelet Transform.
%Input:
%   w:
%       Wavelet coefficients of DTCWT.
%   J:
%       Level of decomposition. Integer.
%   FS_fb1d:
%       First Stage 1d filter bank for 2 trees. Cell array with 2 cells.
%   fb1d:
%       1d filter bank for 2 trees. Cell array with 2 cells.
%
%Output:
%   y:
%       recovered 2D matrix data.
%
% Note:	
%	w{j}{part}{dir}{band}:	
%		j : different level
%		band : different band in one freq quadrant.
%		dir  : dir=1 and dir=2 are symmetric directions
%		part : real or imaginary part (part=dir for real, part~=dir for imaginary)
%
%   Author: Chenzhe Diao
%   Date:   July, 2015

for j = 1:J
    for m = 1:3
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end

y = zeros(size(w{1}{1}{1}{1})*2);

for m = 1:2
    for n = 1:2
        
        LL = w{J+1}{n}{m};
        for j = J:(-1):2
            coeff = [LL, w{j}{n}{m}];
            LL = d2tsynthesis(coeff, 2, fb1d{n},fb1d{m});
        end
        coeff = [LL, w{1}{n}{m}];
        LL = d2tsynthesis(coeff, 2, FS_fb1d{n}, FS_fb1d{m});
        y = y + LL;
    end
end

y = y/4;


y = y*2;    % Normalized to be tight frames











end

