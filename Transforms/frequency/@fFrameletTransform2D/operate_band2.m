function [ w_new ] = operate_band2( obj, fun_handle, w1, w2 )
%OPERATE_BAND2 operation on coefficients of each band, only work on
%hipass bands
%
%
%   Chenzhe
%   April, 2016
%

nL = obj.nlevel;
w_new = w1;

for j = 1:nL
    nB = length(w1{j});
    for iB = 1:nB
        w_new{j}{iB} = fun_handle(w1{j}{iB}, w2{j}{iB});
    end
end





end

