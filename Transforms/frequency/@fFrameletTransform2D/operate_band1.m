function [ w_new ] = operate_band1(obj, fun_handle, w)
%OPERATE_BAND1 operation on coefficients of each band, only work on
%hipass bands
%
%
%   Chenzhe
%   April, 2016
%

nL = obj.nlevel;
w_new = w;

for j = 1:nL
    nB = length(w{j});
    for iB = 1:nB
        w_new{j}{iB} = fun_handle(w{j}{iB});
    end
end




end

