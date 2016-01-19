function [ y ] = DenoiseLocalSoft( x, J, Nsig, filter, nor, x_true , opt)
%Denoise Using Framelet Transform and Local Soft Shrinkage Method
%
% Using old method to input precalculated filter norms.
%
%   Chenzhe Diao


% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);
x_true = symext(x_true,buffer_size);


W = Framelet2d(x, J, filter);
W_true = Framelet2d(x_true, J, filter);

W = normcoef(W,J,nor);
W_true = normcoef(W_true,J,nor);




W = localsoft_test(W, W_true, Nsig, opt);


W = unnormcoef(W,J,nor);
y = iFramelet2d(W, J, filter);

ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);



end

