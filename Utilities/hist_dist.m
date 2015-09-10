function [] = hist_dist(x, Nbin)
%Histogram plot, make the y axis the distribution pdf.
%
%   Chenzhe Diao
%   Aug, 2015

if nargin==1
    Nbin = 10;
end

x = x(:);
lb = min(x);
ub = max(x);
dx = (ub-lb)/(Nbin-1);

xbin = linspace(lb,ub,Nbin);
dist_pdf = histc(x, xbin);


dist_pdf = dist_pdf/length(x)/dx;

bar(xbin, dist_pdf);


end