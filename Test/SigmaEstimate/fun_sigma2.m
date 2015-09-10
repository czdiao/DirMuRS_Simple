function fun_handle = fun_sigma2(x, s)


tmp = @(n1, n2) max(0, x^2 + 2/sqrt(s)*x*n1 + 1/s*n2 -1);
fun_handle = @(n1, n2) tmp(n1, n2).*normpdf(n1, 0, 1).*chi2pdf(n2, s);



end