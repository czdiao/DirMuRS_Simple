function [ y ] = ifDualTree2d_SplitHighLow( w, J, FS_fb1d, fb1d )
%IFDUALTREE2D_SPLITHIGHLOW Summary of this function goes here
%   Detailed explanation goes here

%% To Split Lowpass filters

len = 2*length(w{1}{1}{1}{1});

[u1, u2] = SplitLowOrig;
u1_low = u1.convert_ffilter(len);
u2_low = u2.convert_ffilter(len);

% u1_low = freqfilter1d;
% f = 0:1/len:(len-1)/len;
% f = f*2*pi-pi;
% u1_low.ffilter = ifftshift(fchi(f, -pi/2, pi/2, 189/256, 189/256));
% 
% u2_low = u1_low.fCQF;

%% To Split Hipass filters

[u1, u2] = SplitHaar;
u1_hi = u1.convert_ffilter(len);
u2_hi = u2.convert_ffilter(len);

% u1_hi = freqfilter1d;
% f = 0:1/len:(len-1)/len;
% f = f*2*pi-pi;
% u1_hi.ffilter = ifftshift(fchi(f, -pi/2, pi/2, 189/256, 189/256));
% 
% u2_hi = u1_hi.fCQF;

%% Transform Directly

w = wfft2_dt(w);

for j = 1:J
    for m = 1:12
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end

y = zeros(size(w{1}{1}{1}{1})*2);

for m = 1:2
    for n = 1:2
        
        LL = w{J+1}{n}{m};
        for j = J:(-1):2
            w{j}{n}{m} = CombineHiLow1(w{j}{n}{m}, u1_low, u2_low, u1_hi, u2_hi);
            coeff = [LL, w{j}{n}{m}];
            LL = d2fsynthesis(coeff, 2, fb1d{n},fb1d{m});
        end
        w{1}{n}{m} = CombineHiLow1(w{1}{n}{m}, u1_low, u2_low, u1_hi, u2_hi);
        coeff = [LL, w{1}{n}{m}];
        LL = d2fsynthesis(coeff, 2, FS_fb1d{n}, FS_fb1d{m});
        y = y + LL;
    end
end

y = y/4;


y = y*2;    % Normalized to be tight frames

y = ifft2(y);

y = real(y);


end

function w_new = CombineHiLow1(w, u1_low, u2_low, u1_hi, u2_hi)
%% Combine each band in one level.

w_new = cell(1,3);


tmp1 = fPostCombine(w{1}, u1_low, w{2}, u2_low, 1);
tmp2 = fPostCombine(w{3}, u1_low, w{4}, u2_low, 1);
w_new{1} = fPostCombine(tmp1, u1_hi, tmp2, u2_hi, 2);

tmp1 = fPostCombine(w{5}, u1_low, w{6}, u2_low, 2);
tmp2 = fPostCombine(w{7}, u1_low, w{8}, u2_low, 2);
w_new{2} = fPostCombine(tmp1, u1_hi, tmp2, u2_hi, 1);

tmp1 = fPostCombine(w{9}, u1_hi, w{10}, u2_hi, 2);
tmp2 = fPostCombine(w{11}, u1_hi, w{12}, u2_hi, 2);

w_new{3} = fPostCombine(tmp1, u1_hi, tmp2, u2_hi, 1);


end








