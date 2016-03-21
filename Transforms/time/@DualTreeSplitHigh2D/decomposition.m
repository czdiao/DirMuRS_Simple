function w = decomposition( obj, x )
%DECOMPOSITION Wavelet decomposition function
%
%   This is 2D DT-CWT with Split the highpass
%
%   Chenzhe
%   Jan, 2016


J = obj.nlevel;
FS_fb1d = obj.FirstStageFB;
fb1d = obj.FilterBank;
u_hi = obj.u_hi;

w = cell(1, J+1);
x = x/2;   % to normalize to tight frame

% u1, u2 to split the highpass
u1 = u_hi(1);
u2 = u_hi(2);


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
        w{1}{coltree}{rowtree} = SplitHipass1(H, u1, u2);
        
        % Later Stages
        for j = 2:J
            [L, H] = d2tanalysis(L, 2, fb1d{coltree}, fb1d{rowtree});
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



end


function w = SplitHipass1(H, u1, u2)
%Split Hipass for one level.

w = cell(1,8);

w{1} = PostSplit(H{1},u1, 2);
w{2} = PostSplit(H{1},u2, 2);

w{3} = PostSplit(H{2},u1, 1);
w{4} = PostSplit(H{2},u2, 1);

tmp1 = PostSplit(H{3},u1, 1);
tmp2 = PostSplit(H{3},u2, 1);

w{5} = PostSplit(tmp1,u1, 2);
w{6} = PostSplit(tmp1,u2, 2);

w{7} = PostSplit(tmp2,u1, 2);
w{8} = PostSplit(tmp2,u2, 2);


end

