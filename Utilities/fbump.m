function y = fbump(x,N,choice)
%% Bump function nv s.t. |nv(x)|^2+|nv(-x)|^2 =1
%
%% Description
%  fbump(x) is a function s.t. |nv(x)|^2+|nv(-x)|^2 = 1 for all x
%   1. Default, choice = 1. sin cos type
%        nv = 0;                                   for x < -1;
%        nv = sin(pi/2*((1+x)/2)^N P_N((1-x)/2));  for -1 <= x <= 1;
%        nv = 1;                                   for x > 1,
%        where P_N(x) = \sum_{j=0}^{N-1}(N-1+j choose j)*x^j.
%  2. for choice = 2. square root type
%        |nv(x)|^2 in [-1,1] is a polynoimal of order 2*N+1:
%        |nv(x)|^2 = ((x+1)/2)^{N}*(c_0+c_1*(x+1)/2+...+c_{N-1}*((x+1)/2)^{N-1});
%         with c_j = (-1)^j*(2*N-1,N-1-k)*nchoose(N-1+k,k)
%  3. x,  sampling points
%     N,  smooth factor
%     choice = 1 or 2, use sin method 1 or method 2 as above, default = 1  
%% Examples
%     x = [-1.02:0.01:1.02];
%     y1 = fbump(x,1,1); y2 = fbump(x,2,2); y3 = fbump(x,2,2);
%     plot(x,y1,'r',x,y2,'g',x,y3,'b');
%     x2 = -x; ty2 = fbump(x2,2,2);
%     max(y2.^2+ty2.^2)
%     min(y2.^2+ty2.^2)
%% Copyright
% Copyright (C) 2013. Xiaosheng Zhuang, City U HK

if nargin <= 0
    error('not enough inputs!');
end
if nargin <= 1
    N = 1;
end
if nargin <= 2
    choice = 1;
end


% Method 1: Sin Type
if choice == 1
   y = (x > 1);
   
   tmp = 0;
   for j = [0:N-1]
       tmp = tmp + nchoosek(N-1+j,j).*((1-x)/2).^j; 
   end
   tmp = tmp.*((1+x)/2).^N*pi/2;

   y = y+(x >= -1).*(x <= 1).*sin(tmp);
   return
end

% Method 2: Square Root Type
if choice ~= 1    
    y = (x > 1);
    tmp = 0;
    for k = [0:N-1]
        tmp = tmp + (-1)^k*nchoosek(2*N-1,N-1-k)*nchoosek(N-1+k,k).*((1+x)/2).^k;
    end
    tmp = tmp.*((1+x)/2).^N;
    y = y + (x >= -1).*(x <= 1).*sqrt(tmp);
    return
end

end