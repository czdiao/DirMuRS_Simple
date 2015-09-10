function y = quantization(x, T, alpha, beta)
%QUANTIZATION quantization function, applied in wavelet domain.
%   All the inputs could be matrices.
%
%   Input:
%       x       :       Input coefficient.
%       T       :       Thresholding number, T>=0.
%       alpha   :       alpha*T would be the length of quantization
%                       interval length. alpha >= 0.
%       beta    :       lifting height.
%
%   Notice:
%       1. Hard Thresholding: alpha = 0, beta = 1.
%       2. Soft Thresholding: alpha = 0, beta = 0.
%
%       Only works for real data.
%
% Author:   Chenzhe

y = (abs(x)-T).*(abs(x)>T).*sign(x);

tmp = max(alpha*T, eps);
y = fix(y./tmp).*tmp;
y = y + (0.5*alpha*T + beta*T).*sign(x).*(abs(x)>T);


end