function [ fun_pdf ] = fun_noisypdf( c, cp, sigma )
%FUN_NOISYEXP Summary of this function goes here
%   Detailed explanation goes here

phi = @(x, y) normpdf(x, 0, sigma).*normpdf(y, 0, sigma);
fun = @(x, y) sqrt(3).*abs(c+x)./sqrt((c+x).^2 + (cp+y).^2);

fun_pdf = @(x, y) phi(x, y).*fun(x, y);





end

