function [ y ] = reconstruction( obj )
%RECONSTRUCTION Reconstruction of Dual Tree 2D using Frequency based filter
%banks.
%
%   The transform is performed in frequency domain. The filter banks are of
%   the class freqfilter1d.
%
%   The decomposed coefficients are still saved in real/imaginary parts
%   respectively. (obj.coeff are still real numbers.)
%
%   Chenzhe
%   Feb, 2016
%


w = obj.coeff;
J = obj.nlevel;

if obj.isSameRowColFB
    FS_fb1d_col = obj.FirstStageFB;
    FS_fb1d_row = obj.FirstStageFB;
    fb1d_col = obj.FilterBank;
    fb1d_row = obj.FilterBank;
else
    FS_fb1d_col = obj.FirstStageFB_col;
    FS_fb1d_row = obj.FirstStageFB_row;
    fb1d_col = cell(1,J-1);
    fb1d_row = cell(1,J-1);
    for j = 1:(J-1)
        fb1d_col{j} = obj.FilterBank_col;
        fb1d_row{j} = obj.FilterBank_row;
    end
end

FS_fb1d = obj.FirstStageFB;
fb1d = obj.FilterBank;

w = obj.wfft2_dt(w);

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
            LL = d2fsynthesis(coeff, 2, fb1d_col{n},fb1d_row{m});
        end
        coeff = [LL, w{1}{n}{m}];
        LL = d2fsynthesis(coeff, 2, FS_fb1d_col{n}, FS_fb1d_row{m});
        y = y + LL;
    end
end

y = y/4;


y = y*2;    % Normalized to be tight frames

y = ifft2(y);
y = real(y);




end

