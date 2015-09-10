function [ y ] = iDualTree2d( w, J, FS_filter2d, filterbank2d)
%IDUALTREE2D Inverse transform of 2D Dual Tree Complex Wavelet Transform
%   Input:
%	w, J, FS_filter2d, filer2d are the same as explained in DualTree2d() function
%   Output:
%	y:	restored 2d signal
%
%   Note:
%	already normalized to be tight frames
%
%   This function works for any number of highpass filters. (Split Highpass)



num_hipass = length(w{1}{1}{1});  % the first one is lowpass

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
            LL = synthesis2d(coeff, filterbank2d{row}{col});
        end
        coeff = [LL, w{1}{row}{col}];
        LL = synthesis2d(coeff, FS_filter2d{row}{col});
        y = y + LL;
    end
end

y = y/4;


y = y*2;    % Normalized to be tight frames

end

