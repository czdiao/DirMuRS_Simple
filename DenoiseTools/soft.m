function y = soft(x,T)
% Soft Thresholding function

y = max(abs(x) - T, 0);
y = y./(y+T) .* x;

