function y = reconstruction( obj )
%RECONSTRUCTION Wavelet Reconstruction function
%
%   This function is the inverse of 2D DT-CWT with Split Hipass and lowpass
%
%   This version is called 'real', we require obj.u_hi and obj.u_low
%   to be both real filter banks.
%
%   Chenzhe
%   Jan, 2016
%

w = obj.coeff;
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
            LL = d2tsynthesis(coeff, 2, fb1d{n},fb1d{m});
        end
        w{1}{n}{m} = CombineHiLow1(w{1}{n}{m}, u1_low, u2_low, u1_hi, u2_hi);
        coeff = [LL, w{1}{n}{m}];
        LL = d2tsynthesis(coeff, 2, FS_fb1d{n}, FS_fb1d{m});
        y = y + LL;
    end
end

y = y/4;

y = y*2;    % Normalized to be tight frames




end

function w_new = CombineHiLow1(w, u1_low, u2_low, u1_hi, u2_hi)
%%Combine each band in one level.

w_new = cell(1,3);


tmp1 = PostCombine(w{1}, u1_low, w{2}, u2_low, 1);
tmp2 = PostCombine(w{3}, u1_low, w{4}, u2_low, 1);
w_new{1} = PostCombine(tmp1, u1_hi, tmp2, u2_hi, 2);

tmp1 = PostCombine(w{5}, u1_low, w{6}, u2_low, 2);
tmp2 = PostCombine(w{7}, u1_low, w{8}, u2_low, 2);
w_new{2} = PostCombine(tmp1, u1_hi, tmp2, u2_hi, 1);

tmp1 = PostCombine(w{9}, u1_hi, w{10}, u2_hi, 2);
tmp2 = PostCombine(w{11}, u1_hi, w{12}, u2_hi, 2);

w_new{3} = PostCombine(tmp1, u1_hi, tmp2, u2_hi, 1);


end


