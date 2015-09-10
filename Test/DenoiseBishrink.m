function [ y ] = DenoiseBishrink( x, J, Nsig, filter, nor )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);



W = Framelet2d_new(x, J, filter);

W = normcoef(W,J,nor);

W = thr_bishrink(W, Nsig);

W = unnormcoef(W,J,nor);
y = iFramelet2d_new(W, J, filter);

ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);


end

