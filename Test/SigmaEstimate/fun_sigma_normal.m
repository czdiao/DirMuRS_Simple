function fun_handle = fun_sigma_normal(x, s)



tmp = @(n) max(0, x^2  + 2/sqrt(s)*x*n);
fun_handle = @(n) tmp(n).*normpdf(n, 0, 1);


end