function [ y ] = reconstruction( obj )
%RECONSTRUCTION Reconstruction of fFrameletCrossLv2D
%
%
%   Chenzhe
%   Mar, 2016
%

FfilterBank_col = obj.FilterBank_col;
FfilterBank_row = obj.FilterBank_row;
w = obj.coeff;
w = obj.wfft2(w);   % Change the coeff into frequency domain
J = obj.nlevel;

LL = w{J+1};


for ilevel = J:(-1):1
    ncol = length(FfilterBank_col);
    nrow = length(FfilterBank_row);
    
    Lv = 1;
    len = (ncol-1)*Lv+1;
    
    coeff = cell(0);
    for jj = 1:nrow-1;
        tmp = w{ilevel}(end-len+1:end);
        w{ilevel}(end-len+1:end) = [];
        tmp = synthesisMulLv(FfilterBank_col, tmp, 2, 1, Lv);
        coeff = [tmp, coeff];
    end
    coeff = [LL, coeff];
%     tmp2 = w{ilevel}(end-len+1:end);
%     w{ilevel}(end-len+1:end) = [];
%     tmp2 = synthesisMulLv(FfilterBank_col, tmp2, 2, 1, Lv);
%     coeff = [{LL}, {tmp2}, {tmp}];
    L1 = fsynthesis(FfilterBank_row, coeff, 2, 2);
    coeff = {L1};
    
    len = length(w{ilevel})/(ncol-1);
    for jj = 1:ncol-1
        tmp = synthesisMulLv(FfilterBank_row, w{ilevel}(1:len), 2, 2, Lv+1);
        w{ilevel}(1:len) = [];
        coeff = [coeff, tmp];
    end
    
    LL = fsynthesis(FfilterBank_col, coeff, 2, 1);
    
    
end

y = ifft2(LL);  % change the data back into time domain


end

function y = synthesisMulLv(fb, coeff, rate, dim, Lv)
% perform synthesis operation in 1d for multi-level

low = coeff{end};
coeff(end) = [];
nhi = length(fb)-1;

for j = 1:Lv
    hi = coeff(end-nhi+1 : end);
    coeff(end-nhi+1:end) = [];
    w = [low, hi];
    low = fsynthesis(fb, w, rate, dim);
end

y = low;

end





