function [ w ] = DualTree2d( x, J, FS_fb1d, fb1d )
%DUALTREE2D_NEW Complex Dual Tree Wavelet Transform.
%Input:
%   x:
%       Input 2D matrix signal.
%   J:
%       Level of decomposition. Integer.
%   FS_fb1d:
%       First Stage 1d filter bank for 2 trees. Cell array with 2 cells.
%   fb1d:
%       1d filter bank for 2 trees. Cell array with 2 cells.
%
%Output:	
%	w{j}{part}{dir}{band}:	
%		j : different level
%		band : different band in one freq quadrant.
%		dir  : dir=1 and dir=2 are symmetric directions
%		part : real or imaginary part (part=dir for real, part~=dir for imaginary)
%
%   Author: Chenzhe Diao
%   Date:   July, 2015



w = cell(1, J+1);
x = x/2;   % to normalize to tight frame

%Initialize memory
for j = 1:J+1
    w{j} = cell(1,2);
    for k = 1:2
        w{j}{k} = cell(1,2);
    end
end

for rowtree = 1:2
    for coltree = 1:2
        
        % First Stage
        [L, H] = d2tanalysis(x, 2, FS_fb1d{coltree}, FS_fb1d{rowtree});
        w{1}{coltree}{rowtree} = H;
        
        % Later Stages
        for j = 2:J
            [L, w{j}{coltree}{rowtree}] = d2tanalysis(L, 2, fb1d{coltree}, fb1d{rowtree});
        end
        w{J+1}{coltree}{rowtree} = L;
        
    end
end


for j = 1:J
    for m = 1:3
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end








end

