function [ w ] = fDualTree2d_SplitHigh( x, J, FS_fb1d, fb1d )
%FDUALTREE2D_SPLITHIGH Summary of this function goes here
%   Detailed explanation goes here

%% Directly

[u1, u2] = SplitHaar;

u1 = u1.convert_ffilter(length(x));
u2 = u2.convert_ffilter(length(x));

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
        [L, H] = d2fanalysis(x, 2, FS_fb1d{coltree}, FS_fb1d{rowtree});     % H has 3 cells
        w{1}{coltree}{rowtree} = SplitHipass1(H, u1, u2);
        
        % Later Stages
        for j = 2:J
            [L, H] = d2fanalysis(L, 2, fb1d{coltree}, fb1d{rowtree});
            w{j}{coltree}{rowtree} = SplitHipass1(H, u1, u2);
        end
        w{J+1}{coltree}{rowtree} = L;
        
    end
end


for j = 1:J
    for m = 1:8
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end

w = wifft2_dt(w);



end

function w = SplitHipass1(H, u1, u2)
%Split Hipass for one level.

w = cell(1,8);

w{1} = fPostSplit(H{1},u1, 2);
w{2} = fPostSplit(H{1},u2, 2);

w{3} = fPostSplit(H{2},u1, 1);
w{4} = fPostSplit(H{2},u2, 1);

tmp1 = fPostSplit(H{3},u1, 1);
tmp2 = fPostSplit(H{3},u2, 1);

w{5} = fPostSplit(tmp1,u1, 2);
w{6} = fPostSplit(tmp1,u2, 2);

w{7} = fPostSplit(tmp2,u1, 2);
w{8} = fPostSplit(tmp2,u2, 2);


end


