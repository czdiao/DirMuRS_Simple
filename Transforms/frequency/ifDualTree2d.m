function [ y ] = ifDualTree2d( w, J, FS_fb1d, fb1d )
%IFDUALTREE2D Summary of this function goes here
%   Detailed explanation goes here

w = wfft2_dt(w);

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
            LL = d2fsynthesis(coeff, 2, fb1d{n},fb1d{m});
        end
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

