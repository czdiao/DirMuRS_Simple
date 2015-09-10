function [ y ] = ifDualTree2d_SplitHigh( w, J, FS_fb1d, fb1d )
%IFDUALTREE2D_SPLITHIGH Summary of this function goes here
%   Detailed explanation goes here


%% Directly

u1 = filter1d([-0.5, 0.5],-1);
u2 = filter1d([-0.5, -0.5], -1);

len = 2*length(w{1}{1}{1}{1});

u1 = u1.convert_ffilter(len);
u2 = u2.convert_ffilter(len);


w = wfft2_dt(w);

for j = 1:J
    for m = 1:8
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end

y = zeros(size(w{1}{1}{1}{1})*2);

for m = 1:2
    for n = 1:2
        
        LL = w{J+1}{n}{m};
        for j = J:(-1):2
            w{j}{n}{m} = CombineHipass1(w{j}{n}{m}, u1, u2);
            coeff = [LL, w{j}{n}{m}];
            LL = d2fsynthesis(coeff, 2, fb1d{n},fb1d{m});
        end
        w{1}{n}{m} = CombineHipass1(w{1}{n}{m}, u1, u2);
        coeff = [LL, w{1}{n}{m}];
        LL = d2fsynthesis(coeff, 2, FS_fb1d{n}, FS_fb1d{m});
        y = y + LL;
    end
end

y = y/4;


y = y*2;    % Normalized to be tight frames

y = ifft2(y);


end


function w_new = CombineHipass1(w, u1, u2)
%% Combine each band in one level.

w_new = cell(1,3);

w_new{1} = fPostCombine(w{1}, u1, w{2}, u2, 2);
w_new{2} = fPostCombine(w{3}, u1, w{4}, u2, 1);

tmp1 = fPostCombine(w{5}, u1, w{6}, u2, 2);
tmp2 = fPostCombine(w{7}, u1, w{8}, u2, 2);

w_new{3} = fPostCombine(tmp1, u1, tmp2, u2, 1);



end











