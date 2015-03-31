function y = d1tconv(v,u,stp,choice)
%% 1D time domain convolution
%
% INPUT:
%   u: filter  
%   stp : starting point of u = [u(stp),u(stp+1),...,u(0),...];
%   v: signal
%   choice : extension choice, see "extend"
% OUPUT:
%   y: circular convulution of v*u;
% 
%%

if nargin < 4
    choice = 0;
end

N = length(v);

ve = extend(v,choice);

Ne = length(ve);
temp = cconv(u,v,Ne);
y = circshift(temp,[0, stp]);

if choice ~= 0
    y = y(1:N);
end

end