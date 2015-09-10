function [ y ] = DenoiseLocalSoft( x, J, Nsig, filter, nor, x_true )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here


% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);
x_true = symext(x_true,buffer_size);


W = Framelet2d_new(x, J, filter);
W_true = Framelet2d_new(x_true, J, filter);

W = normcoef(W,J,nor);
W_true = normcoef(W_true,J,nor);




W = localsoft_test(W, W_true, Nsig, 'local_soft_m6');


W = unnormcoef(W,J,nor);
y = iFramelet2d_new(W, J, filter);

ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);



end

