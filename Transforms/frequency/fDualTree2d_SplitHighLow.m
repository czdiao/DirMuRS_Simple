function [ w ] = fDualTree2d_SplitHighLow( x, J, FS_fb1d, fb1d )
%FDUALTREE2D_SPLITHIGHLOW Summary of this function goes here
%   Detailed explanation goes here

%% To Split Lowpass filters

[u1, u2] = SplitLowOrig;
u1_low = u1.convert_ffilter(length(x));
u2_low = u2.convert_ffilter(length(x));

% len = length(x);
% u1_low = freqfilter1d;
% f = 0:1/len:(len-1)/len;
% f = f*2*pi-pi;
% u1_low.ffilter = ifftshift(fchi(f, -pi/2, pi/2, 189/256, 189/256));
% u2_low = u1_low.fCQF;

%% To Split Hipass filters

[u1, u2] = SplitHaar;
u1_hi = u1.convert_ffilter(length(x));
u2_hi = u2.convert_ffilter(length(x));

% len = length(x);
% u1_hi = freqfilter1d;
% f = 0:1/len:(len-1)/len;
% f = f*2*pi-pi;
% u1_hi.ffilter = ifftshift(fchi(f, -pi/2, pi/2, 189/256, 189/256));
% u2_hi = u1_hi.fCQF;


%% Transform
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
        w{1}{coltree}{rowtree} = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi);
        
        % Later Stages
        for j = 2:J
            [L, H] = d2fanalysis(L, 2, fb1d{coltree}, fb1d{rowtree});
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

% Convert the coefficients to time domain.
w = wifft2_dt(w);


end


function w = SplitHiLow1(H, u1_low, u2_low, u1_hi, u2_hi)
%% Split Hipass and Lowpass
%H{3} : {LH}, {HL}, {HH}

w = cell(1,12);

% Split Hipass
tmp1 = fPostSplit(H{1},u1_hi, 2);
tmp2 = fPostSplit(H{1},u2_hi, 2);
% Split Lowpass
w{1} = fPostSplit(tmp1,u1_low, 1);
w{2} = fPostSplit(tmp1,u2_low, 1);
w{3} = fPostSplit(tmp2,u1_low, 1);
w{4} = fPostSplit(tmp2,u2_low, 1);

% Split Hipass
tmp1 = fPostSplit(H{2},u1_hi, 1);
tmp2 = fPostSplit(H{2},u2_hi, 1);
% Split Lowpass
w{5} = fPostSplit(tmp1,u1_low, 2);
w{6} = fPostSplit(tmp1,u2_low, 2);
w{7} = fPostSplit(tmp2,u1_low, 2);
w{8} = fPostSplit(tmp2,u2_low, 2);

% Split HH
tmp1 = fPostSplit(H{3},u1_hi, 1);
tmp2 = fPostSplit(H{3},u2_hi, 1);
w{9}  = fPostSplit(tmp1,u1_hi, 2);
w{10} = fPostSplit(tmp1,u2_hi, 2);
w{11} = fPostSplit(tmp2,u1_hi, 2);
w{12} = fPostSplit(tmp2,u2_hi, 2);

end




