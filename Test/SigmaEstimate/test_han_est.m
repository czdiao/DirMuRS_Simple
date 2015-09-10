
clear;clc;

s = 49;

% xrange = 0;
xrange = 0:0.1:2;
len = length(xrange);


E2 = zeros(len, 1);
% for i = 1:len
%     x = xrange(i);
%     pdffun = fun_sigma2(x, s);
%     
%     E2(i) = integral2(pdffun,-inf, inf, 0, inf, 'Method', 'iterated');
%     
%     if mod(i,5)==0
%         fprintf('i = %d, len = %d\n', i, len);
%     end
%     
% end



E_chi2 = zeros(len, 1);
bound = inf;

for i = 1:len
    x = xrange(i);
    pdffun = fun_sigma(x, s);
    
    E_chi2(i) = integral(pdffun, -bound, bound);
    
    if mod(i,5)==0
        fprintf('i = %d, len = %d\n', i, len);
    end
    
end


E_normal = zeros(len, 1);
bound = inf;

for i = 1:len
    x = xrange(i);
    pdffun = fun_sigma_normal(x, s);
    
    E_normal(i) = integral(pdffun, -100, 100);
    
    if mod(i,5)==0
        fprintf('i = %d, len = %d\n', i, len);
    end
    
end



E_chi2 = sqrt(E_chi2);
E2 = sqrt(E2);
E_normal = sqrt(E_normal);


%% Try

Ssig_est = 0:0.01:10;
Nsig = 3;

lambda1 = 0.2834;
lambda2 = 1.0;
alpha = 0.43;
Ssig_est = Ssig_est./Nsig;
Ssig_tmp1 = Ssig_est.*(Ssig_est>lambda2);
Ssig_tmp2 = (Ssig_est.^2-lambda1^2).*(Ssig_est<=lambda2);
Ssig_tmp2 = Ssig_tmp2.*(Ssig_tmp2>0);
Ssig_tmp2 = Ssig_tmp2.^alpha * (lambda2/(lambda2^2-lambda1^2)^alpha);
Ssig = Ssig_tmp1 + Ssig_tmp2;
Ssig = max(Ssig, eps);
Ssig = Ssig.*Nsig;
Ssig_est = Ssig_est.*Nsig;


%%
x = 0:0.01:4;
y = x.^2 + (1-2/(9*s)).^3-1;
y = max(eps, y);
y = sqrt(y);


%%
figure; hold on;
% plot(E_normal, xrange, 'r', E_chi2, xrange, 'g', E2, xrange, 'b', Ssig_est/Nsig, Ssig/Nsig, 'k');
% legend('normal','\chi^2', 'both', 'try');
plot(E_normal, xrange, 'r', E_chi2, xrange, 'g', Ssig_est/Nsig, Ssig/Nsig, 'b', y, x, 'k');
legend('normal','\chi^2', 'try', 'try2');
grid on
xlabel('$\hat{\sigma}/\sigma_n$','Interpreter','LaTex')
ylabel('$\sigma/\sigma_n$','Interpreter','LaTex')
xlim([0,1.4]);



% f1 = fun_sigma(0,s);
% f2 = fun_sigma2(0,s);
% 
% n2 = 0:0.1:100;
% bound = inf;
% 
% y1 = f1(n2);
% plot(n2, y1)
% % integral(f1, 0, 100)
% 
% for i = 1:length(n2)
%     x = n2(i);
%     ftmp = @(n1) f2(n1, x);
%     y2(i) = integral(ftmp, -inf, inf);
%     
% end
% 
% figure; plot(n2, y2)






