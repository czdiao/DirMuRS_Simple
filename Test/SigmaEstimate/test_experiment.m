clear;

%% Load Noise
sigmaN = [5, 10, 30, 50, 80, 100];
len = length(sigmaN);
load('noise_thresh.mat','noise512');

%% Load Image
imgName    = 'Lena512.png';
x_true = double(imread(imgName));

%% Load Filter
filter = Daubechies8_1d;
load('nor_daubechies8.mat','nor');
nlevel = 5;

%% Noisy
Nsig = sigmaN(1);
n = noise512{1};
x_noisy = x_true + n;


%% Transform
L = length(x_noisy); % length of the original image.
buffer_size = L/2;
x_noisy = symext(x_noisy,buffer_size);
x_true = symext(x_true,buffer_size);


W = Framelet2d(x_noisy, nlevel, filter);
W_true = Framelet2d(x_true, nlevel, filter);


%% Test beta distribution
%
% load('rtable.mat', 'r', 'beta');
% 
% 
% 
% count = 0;
% for i = 3
%     for iband = 1:3
%         for k = 1:length(W_true{i}{iband})-8
%             for kk = 1:length(W_true{i}{iband})-8
%                 
%                 count = count+1;
%                 data = W_true{i}{iband}(k:k+8,kk:kk+8);
%                 betahat(count) = Calbeta(data(:), length(data(:)),r, beta );
%             end
%         end
%     end
%     
% end
% 
% hist(betahat, 20)


%%

W = normcoef(W,nlevel,nor);
W_true = normcoef(W_true,nlevel,nor);

var_noisy = cal_variance(W);
var_true = cal_variance(W_true);
var_est = sqrt(max(eps, var_noisy.^2-Nsig^2));

% figure;
% title('Prior distribution of original sigma')
% subplot(2,2,4);
% hist_dist(var_true, 10000); grid on;xlim([0,50])
% title(imgName);


var_noisy = var_noisy/Nsig;
var_true = var_true/Nsig;
var_est = var_est/Nsig;


%% Bins with var_est
% ub = max(var_est);
% lb = min(var_est);
% 
% Nbin = 1000;
% dx = (ub-lb)/Nbin;
% 
% xbin = linspace(lb,ub,Nbin+1);
% sigma_exp = zeros(Nbin+1,1);
% var1 = zeros(Nbin+1,1);
% for i = 0:Nbin
%     a = lb+i*dx;
%     b = a + dx;
%     index = (var_est>=a) & (var_est<b);
%     count = sum(index);
%     sigma_exp(i+1) = sum(var_true(index))/count;
%     var1(i+1) = var(var_true(index));
% end
% 
% figure;
% plot(xbin, sigma_exp)
% xlim([0,3])
% grid on
% 
% plot(var_noisy, var_est)
% plot(var_noisy, var_true, '.')
% plot(xbin, sigma_exp);
% 
% xlim([0,2])
% ylim([0,2])
% 
% ax = gca;
% set(ax,'XTick',0:0.2:2)
% set(ax,'YTick',0:0.2:2)


%% Bins with var_noisy
ub = max(var_noisy);
lb = min(var_noisy);

Nbin = 1000;
dx = (ub-lb)/Nbin;

xbin = linspace(lb,ub,Nbin+1);
sigma_exp = zeros(Nbin+1,1);
var2 = zeros(Nbin+1,1);
for i = 0:Nbin
    a = lb+i*dx;
    b = a + dx;
    index = (var_noisy>=a) & (var_noisy<b);
    count = sum(index);
    sigma_exp(i+1) = sum(var_true(index))/count;
    var2(i+1) = var(var_true(index));

end



% figure;
hold on
plot(xbin.^2, sigma_exp, 'b')
grid on
xlim([0,2.5])
% h = legend('$\sigma_n = 5$','$\sigma_n = 50$','$\sigma_n = 100$');
% set(h, 'Interpreter', 'LaTex');
xlabel('$(\sigma_y/\sigma_n)^2$', 'Interpreter', 'LaTex')
ylabel('$E(\sigma/\sigma_n)$', 'Interpreter', 'LaTex')
title('Conditional Expectation $E(\sigma|\sigma_y)$ from experiments', 'Interpreter', 'LaTex')

% 
% figure;
% plot(var_noisy, var_est, '.b')
% grid on
% 
% 
% figure;
% plot(var1);grid on
% 
% figure;
% plot(var2); grid on
% 
% figure;
% plot(var1-var2); grid on


%%

% clear;
% load('variance_4pic')
% 
% var_dist = DistOfData(v, 10000);
% % psigma = @(x) pdf(var_dist, x);
% 
% s = 49;
% Nsig = 50;
% 
% Nsig_range = 100;
% 
% % figure;
% 
% for Nsig = Nsig_range
% range = 1:3*Nsig;
% E = zeros(1, length(range));
% 
% for i = 1:length(range)
%     sigma_y = range(i);
%     p1 = @(sigma) pdf(var_dist, sigma).*condpdf(sigma_y, sigma, Nsig, s);
%     p_y = integral(p1, 0, sigma_y);
%     
%     p2 = @(sigma) sigma.*p1(sigma)/p_y;
%     E(i) = integral(p2, 0, sigma_y);
%     
% end
% 
% y_norm = range/Nsig;
% E_norm = E/Nsig;
% plot(y_norm.^2, E_norm.^2, 'b');
% grid on
% xlabel('$\sigma_y/\sigma_n$','Interpreter', 'LaTex');
% ylabel('$E(\sigma/\sigma_n|\sigma_y)$','Interpreter', 'LaTex');
% % title('$\sigma_n=50$','Interpreter', 'LaTex');
% hold on
% 
% 
% end
% 
% % 5, 25, 50
% x = 0:0.1:9;
% plot(x, x, 'k')
% h = legend('$\sigma = 5$','$\sigma = 50$','$\sigma = 100$', '$y=x$');
% set(h,'Interpreter', 'LaTex');
% 
% 
% figure;
% plot(sqrt(max(0, y_norm.^2-1)), E_norm);
% grid on
% xlabel('$\hat{\sigma}/\sigma_n$','Interpreter', 'LaTex');
% ylabel('$E(\sigma/\sigma_n|\sigma_y)$','Interpreter', 'LaTex');
% 
% title('$\sigma_n=50$','Interpreter', 'LaTex');
% 
% 
% 
% range = 0:0.01:10;
% sigma_cal = zeros(length(range), 1);
% 
% for i = 1:length(range)
%     sigma_noisy = range(i);
%     sigma = 0:0.01:sigma_noisy;
%     c_pdf = condpdf(sigma_noisy, sigma, 49);
%     [M, index] = max(c_pdf);
%     sigma_cal(i) = sigma(index);
%         
% end
% figure;
% plot(range, sigma_cal)









%% Recovery
% W = unnormcoef(W,nlevel,nor);
% W_true = unnormcoef(W_true,nlevel,nor);
% 
% y = iFramelet2d(W, nlevel, filter);
% y_true =  iFramelet2d(W_true, nlevel, filter);
% 
% ind = buffer_size+1 : buffer_size+L;
% y = y(ind,ind);
% y_true = y_true(ind,ind);



