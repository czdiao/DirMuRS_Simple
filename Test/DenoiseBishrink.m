function [ y ] = DenoiseBishrink( x, J, Nsig, filter, nor )
%Denoise Using Framelets and Bivariate Shrinkage
%
% Using old method to input precalculated filter norms.
%
%   Chenzhe Diao


% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);



W = Framelet2d(x, J, filter);

W = normcoef(W,J,nor);

W = thr_bishrink(W, Nsig);

W = unnormcoef(W,J,nor);
y = iFramelet2d(W, J, filter);

ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);


end

