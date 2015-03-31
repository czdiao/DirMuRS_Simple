function y = d2fconv(fv,fu)
%% 2D convolution in frequency domain
%
%  INPUT:
%    fv: signal in frequency domain
%    fu: filter in frequency domain same size as fv;
%  OUTPUT:
%    y = fv.*fu
 
y = fv.*fu;

end