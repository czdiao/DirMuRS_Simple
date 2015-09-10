%%

clear;
load('variance_4pic')

% load('variance_fingerprint.mat');
% v = var_true;

var_dist = DistOfData(v, 10000);
% psigma = @(x) pdf(var_dist, x);

s = 49;
% figure;


Nsig = 100;
range = (0.2:0.04:sqrt(2.6))*Nsig;
E = zeros(1, length(range));

for i = 1:length(range)
    sigma_y = range(i);
    p1 = @(sigma) pdf(var_dist, sigma).*condpdf(sigma_y, sigma, Nsig, s);
    p_y = integral(p1, 0, sigma_y);
    
    p2 = @(sigma) sigma.*p1(sigma)/p_y;
    E(i) = integral(p2, 0, sigma_y);
    
end

y_norm = range/Nsig;
E_norm = E/Nsig;
% plot(y_norm.^2, E_norm.^2, 'b');
% grid on
% 
% % title('$\sigma_n=50$','Interpreter', 'LaTex');
% hold on
% xlim([0,3])

%%
x = y_norm.^2;
y = E_norm.^2;
% figure;
% y1 = 4*x/25+0.2; y1 = y1.*x;

% plot(x, y); grid on; hold on; xlim([0,2.5])
% plot(x, y1) 

% figure;
% err = y1-y; %err = err/max(err);
% plot(x, err, 'b.-'); grid on;hold on; xlim([0,2.5]);
% plot(x, err./(x.*(2.50-x).^2)); xlim([0,2.2]);

% yt = y1 - 0.9*(0.16*x.^2+0.03).*(2.5-x).^2.*x;
% plot(x, y); grid on; hold on; xlim([0, 2.5]);

% plot(x, E_norm./sqrt(x), 'r.-'); grid on; hold on; xlim([0, 2.5]);
% plot(x, 0.9*(0.16*x.^2+0.03).*(2.5-x).^2.*x);xlim([0,2.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sigma = 100
p1 = -0.19964;
p2 = 0.91041;
p3 = -1.0431;
p4 = 0.29835;
p5 = 0.088331;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% yt1 = p1*x.^4 + p2*x.^3 +p3*x.^2 + p4*x +p5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sigma = 5
p1 = -0.024297;
p2 = 0.035368;
p3 = 0.23881;
p4 = -0.32861;
p5 = 0.48456;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% yt2 = p1*x.^4 + p2*x.^3 +p3*x.^2 + p4*x +p5;


% New fit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sigma = 5


p1 = 0.51727;
p2 = -0.70206;
p3 = 0.60501;
p4 = 0;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xt = sqrt(x);
yt2 = p1*xt.^3 + p2*xt.^2 + p3*xt + p4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sigma = 100

p1 = 0.61518;
p2 = -0.74155;
p3 = 0.079357;
p4 = 0.14962;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yt1 = p1*xt.^4 + p2*xt.^3 + p3*xt.^2 + p4*xt;



lambda = log(Nsig/5)/log(20);

yt = lambda*yt1 + (1-lambda)*yt2;

% figure;
% plot(x, yt.*sqrt(x), 'r',x,sqrt(y),'g'); grid on; hold on; xlim([0, 2.5]);
  
% plot(xt, yt, 'r', xt,sqrt(y),'g'); grid on; hold on; xlim([0, 1.53]);

% figure;
plot(xt,y,'r'); grid on; hold on; xlim([0, 1.6]);


% Wsig = x;
% Ssig = E_norm;
% 
% save('SigmaCal5.mat', Wsig, Ssig);

% yt = asin(err).*(x<1.5)+(pi-asin(err)).*(x>=1.5);
% plot(x, yt, 'b.-'); grid on;hold on; xlim([0,2.5]);
% ax = gca;
% set(ax,'YTick',0:pi/4:pi)
% ylim([0,pi]);

% plot(x, yt./x);
% plot(x, asin(err/max(err))+floor(err/max(err))*pi ); grid on;hold on; xlim([0,2.5]);

% plot(x, y)
% plot(x, y1)

% yt = sin(xt.^5/2.5^5*pi).*(2.5-xt).^2; figure;plot(xt, yt);grid on

% 5, 25, 50
% x = 0:0.1:10;
% plot(x, x, 'k')
% h = legend('$\sigma_n = 5$','$\sigma_n = 50$','$\sigma_n = 100$');
% set(h,'Interpreter', 'LaTex');
% 
% 
% figure;
% plot(sqrt(max(0, y_norm.^2-1)), E_norm);
% grid on
% xlabel('$(\sigma_y/\sigma_n)^2$','Interpreter', 'LaTex');
% ylabel('$E((\sigma/\sigma_n)^2|\sigma_y)$','Interpreter', 'LaTex');

% title('Conditional Expectation $E(\sigma|\sigma_y)$ from Calculation', 'Interpreter', 'LaTex')



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








