function nor = CalFilterNorm_blur(obj, signal_size, fker)
%CALFILTERNORM_BLUR filter norm calculation could be based on getFrames(), 
%
%   This function is similar to CalFilterNorm(). However, if the signal is
%   firstly blurred by kernel ker(x), the effect would be same as the
%   frames blurred by conjugate flip of ker:
%       ker_star = conj(ker(-x))
%       fr_blurred = fr \convolve ker_star
%
%   Need to be tested again.
%
%   Chenzhe
%   Jun, 2016
%

if nargin == 1
    signal_size = [512, 512];
end

nL = obj.level_norm;
obj.nlevel = nL;
fr = obj.getFrames_blur(signal_size(1), fker);

nor = cell(1, nL);
for j = 1:nL
    nb = length(fr{j});
    nor{j} = cell(1, nb);
    for ib = 1:nb
        nor{j}{ib} = norm(abs(fr{j}{ib}), 'fro');
    end
end





end

