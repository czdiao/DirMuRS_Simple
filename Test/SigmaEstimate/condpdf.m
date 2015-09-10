function c_pdf = condpdf(sigma_noisy, sigma, Nsig, s)
%Conditional pdf of p(sigma_noisy|sigma)
%sigma is the variance of original image
%Nsig is the noisy level
%s is the degree of freedom of chi2
%
%   Chenzhe Diao
%   Aug, 2015


tmp = (sigma_noisy.^2-sigma.^2)*s/Nsig^2;
c_pdf = 2*sigma_noisy.*chi2pdf(tmp, s).*(tmp>=0);

end