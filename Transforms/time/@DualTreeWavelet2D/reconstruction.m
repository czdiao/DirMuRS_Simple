function y = reconstruction( obj)
%RECONSTRUCTION Wavelet Reconstruction function
%
%   This function is the inverse of 2D DT-CWT
%
%   Chenzhe
%   Jan, 2016
%

J = obj.nlevel;
FS_fb1d = obj.FirstStageFB;
fb1d = obj.FilterBank;
w = obj.coeff;

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
            LL = d2tsynthesis(coeff, 2, fb1d{n},fb1d{m});
        end
        coeff = [LL, w{1}{n}{m}];
        LL = d2tsynthesis(coeff, 2, FS_fb1d{n}, FS_fb1d{m});
        y = y + LL;
    end
end

y = y/4;

y = y*2;    % Normalized to be tight frames



end

