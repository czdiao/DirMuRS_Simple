function w = decomposition( obj, x )
%DECOMPOSITION Wavelet decomposition function
%
%   This is 2D DT-CWT with Split the highpass and lowpass
%
%   This version is called 'real', we require obj.u_hi and obj.u_low
%   to be both real filter banks.
%
%   Chenzhe
%   Jan, 2016


J = obj.nlevel;
FS_fb1d = obj.FirstStageFB;
fb1d = obj.FilterBank;
u_hi = obj.u_hi;
u_low = obj.u_low;


u1_hi = u_hi(1);
u2_hi = u_hi(2);

% filters to split the low pass filters
u1_low = u_low(1);
u2_low = u_low(2);

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
        w{1}{coltree}{rowtree} = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi);
        
        % Later Stages
        for j = 2:J
            [L, H] = d2tanalysis(L, 2, fb1d{coltree}, fb1d{rowtree});
            w{j}{coltree}{rowtree} = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi);
        end
        w{J+1}{coltree}{rowtree} = L;
        
    end
end


for j = 1:J
    for m = 1:12
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end





end


function w = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi)
%%Split Hipass and Lowpass
%H{3} : {LH}, {HL}, {HH}

w = cell(1,12);

% Split Hipass
tmp1 = PostSplit(H{1},u1_hi, 2);
tmp2 = PostSplit(H{1},u2_hi, 2);
% Split Lowpass
w{1} = PostSplit(tmp1,u1_low, 1);
w{2} = PostSplit(tmp1,u2_low, 1);
w{3} = PostSplit(tmp2,u1_low, 1);
w{4} = PostSplit(tmp2,u2_low, 1);

% Split Hipass
tmp1 = PostSplit(H{2},u1_hi, 1);
tmp2 = PostSplit(H{2},u2_hi, 1);
% Split Lowpass
w{5} = PostSplit(tmp1,u1_low, 2);
w{6} = PostSplit(tmp1,u2_low, 2);
w{7} = PostSplit(tmp2,u1_low, 2);
w{8} = PostSplit(tmp2,u2_low, 2);

% Split HH
tmp1 = PostSplit(H{3},u1_hi, 1);
tmp2 = PostSplit(H{3},u2_hi, 1);
w{9}  = PostSplit(tmp1,u1_hi, 2);
w{10} = PostSplit(tmp1,u2_hi, 2);
w{11} = PostSplit(tmp2,u1_hi, 2);
w{12} = PostSplit(tmp2,u2_hi, 2);

end


