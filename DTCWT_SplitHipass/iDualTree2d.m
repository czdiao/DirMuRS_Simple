function [ y ] = iDualTree2d( w, J, FS_filter2d, filter2d)
%IDUALTREE2D Summary of this function goes here
%   Detailed explanation goes here

num_hipass = length(filter2d{1}{1})-1;  % the first one is lowpass

for j = 1:J
    for m = 1:num_hipass
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end

y = zeros(size(w{1}{1}{1}{1})*2);

for row = 1:2
    for col = 1:2
        LL = w{J+1}{row}{col};
            for j = J:(-1):2
                coeff = [LL, w{j}{row}{col}];
                LL = synthesis2d(coeff, filter2d{row}{col});
            end
            coeff = [LL, w{1}{row}{col}];
            LL = synthesis2d(coeff, FS_filter2d{row}{col});
            y = y + LL;
    end
end

y = y/4;


y = y*2;    % Debug, to make the same normalization as Selesnick

end

