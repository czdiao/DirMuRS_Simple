function[y] = expand_d3(x)

[P,N,M] = size(x);
P = P*2;
N = N*2;
M = M*2;

y = zeros(P,N,M);
y(1:2:P,1:2:N,1:2:M) = x;
y(1:2:P,1:2:N,2:2:M) = x;
y(1:2:P,2:2:N,1:2:M) = x;
y(1:2:P,2:2:N,2:2:M) = x;
y(2:2:P,1:2:N,1:2:M) = x;
y(2:2:P,1:2:N,2:2:M) = x;
y(2:2:P,2:2:N,1:2:M) = x;
y(2:2:P,2:2:N,2:2:M) = x;

