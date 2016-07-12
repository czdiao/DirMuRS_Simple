function [ fr_real, fr_imag ] = getFramesReal( obj, N, fker )
%GETFRAMESREAL For complex framelet, only calculate the real and imaginary
%part of the frames.
%
%   This is primarily used for visualization.
%
%
%   ker is the blur kernel. See getFrames_blur() for details.
%
%   Chenzhe Diao
%   Jun, 2016
%

if nargin == 2
    fr = obj.getFrames(N);
elseif nargin ==3
    fr = obj.getFrames_blur(N, fker);
else
    error('Wrong number of inputs in getFramesReal');
end

nL = obj.nlevel;

fr_real = fr;
fr_imag = fr;

for j = 1:nL
    nb = length(fr{j});
    for ib = 1:nb
        fr_real{j}{ib} = real(fr{j}{ib});
        fr_real{j}{ib} = fftshift(fr_real{j}{ib});  % not necessary, only for visual effect
        
        fr_imag{j}{ib} = imag(fr{j}{ib});
        fr_imag{j}{ib} = fftshift(fr_imag{j}{ib});  % not necessary, only for visual effect
    end
end



end

