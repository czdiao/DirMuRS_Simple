function [ w ] = decomposition( obj, x )
%DECOMPOSITION Decomposition of Dual Tree 2D using Frequency based filter
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


x = fft2(x);
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

% FS_fb1d = obj.FirstStageFB;
% fb1d = obj.FilterBank;

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
        [L, H] = d2fanalysis(x, 2, FS_fb1d_col{coltree}, FS_fb1d_row{rowtree});
        w{1}{coltree}{rowtree} = H;
        
        % Later Stages
        for j = 2:J
            [L, w{j}{coltree}{rowtree}] = d2fanalysis(L, 2, fb1d_col{coltree}, fb1d_row{rowtree});
        end
        w{J+1}{coltree}{rowtree} = L;
        
    end
end


for j = 1:J
    for m = 1:3
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end

w = obj.wifft2_dt(w);


end

