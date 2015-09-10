function [ w ] = fDualTree2d( x, J, FS_fb1d, fb1d )
%FDUALTREE2D Summary of this function goes here
%   Detailed explanation goes here


x = fft2(x);

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
        [L, H] = d2fanalysis(x, 2, FS_fb1d{coltree}, FS_fb1d{rowtree});
        w{1}{coltree}{rowtree} = H;
        
        % Later Stages
        for j = 2:J
            [L, w{j}{coltree}{rowtree}] = d2fanalysis(L, 2, fb1d{coltree}, fb1d{rowtree});
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

w = wifft2_dt(w);


end

