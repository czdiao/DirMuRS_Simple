function fun_handle = fun_sigma(x, s)



tmp = @(n) max(0, x^2  + 1/s*n -1);


fun_handle = @(n) tmp(n).*chi2pdf(n, s);


end