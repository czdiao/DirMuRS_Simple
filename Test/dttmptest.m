%% Struct for 2d tensor product filter


clear; 

%% Set Home Path and Add to Path
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% addpath(genpath(HOME_PATH));

%% test for PR
% imgName    = 'Lena512.png';
% x = double(imread(imgName));

% x = rand(512);
% [FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
% [FS_filter2d, filterbank2d] = DualTreeFilter2d;
% filterbank2d = Daubechies8_2d;
% 
% w = Framelet2d(x, 4, filterbank2d);
% y = iFramelet2d(w, 4, filterbank2d);

% w = DualTree2d_SplitLow(x, 5, FS_filter2d, filter2d);
% y = iDualTree2d_SplitLow(w,5, FS_filter2d, filter2d);


% u1.filter = [-0.5, 0.5];
% u1.start_pt = -1;
% u2.filter = [-0.5, -0.5];
% u2.start_pt = -2;
% 
% for j =1:3
%     tmp1 = SplitFilter2d(w{j}{1},u1, 1);
%     tmp2 = SplitFilter2d(w{j}{1},u2, 1);
%     w{j}{1} = tmp1;
%     w{j} = InsertCell(w{j}, tmp2, 2);
% end
% for j = 1:3
%     w{j}{1} = CombineFilter2d(w{j}{1}, u1, w{j}{2}, u2, 1);
%     w{j} = DeleteCell(w{j}, 2);
% end


% y = iFramelet2d(w, 3, FS_filter2d{1}{2}, filter2d{2}{1});

% for i = 1:20
%     w = DualTree2d(x, 5, FS_filter2d, filterbank2d);
%     y = iDualTree2d(w,5, FS_filter2d, filterbank2d);
%     
%     
% end
% 
% err = max(max(abs(x-y)))

%%


% load('nor_dualtree_noise.mat')
% load('nor_selesnick_Q1Haar.mat')

% load('nor_dualtree_noise.mat');
% nor_noise = nor;
% load('nor_selesnick_OrigHaar.mat');
% nor_selesnick = nor;
% 
% for i=5:5
%     for tree1=1:1
%         for tree2=1:1
%             fprintf('level=%d, t1=%d, t2=%d:\n', i, tree1, tree2);
%             n_noise = cell2mat(nor_noise{i}{tree1}{tree2})
%             n_selesnick = cell2mat(nor_selesnick{i}{tree1}{tree2})
%        end
%     end
% end
% 
% n_noise./n_selesnick

% [FS_filter2d, filter2d] = DualTreeFilter2d;

% filter_norm = zeros(1,3);
% for i = 1:3
%     filter_norm(i) = sqrt(Filter2SqNorm(FS_filter2d{1}{1}(i+1)));
% end
% filter_norm


%%
% tmp = zeros(1,7);
% isklen = length(PSNR_matrix(:,1,1));
% ittlen = length(PSNR_matrix(1,:,1));
% 
% err = zeros(isklen, ittlen);
% 
% comp = [37.84, 34.18, 29.35, 26.86, 25.71, 23.53, 22.64];
% 
% for isk=1:length(PSNR_matrix(:,1,1))
%     for itt = 1:length(PSNR_matrix(1,:,1))
%         for i = 1:7
%             tmp(i) = PSNR_matrix(isk, itt, i);
%         end
%         err(isk, itt) = max(comp - tmp);
%     end
% end
% 
% min(min(err))

%% Plot real/imaginary norm ratio

% load('nor_DT_6level.mat','nor');
% 
% count = 0;
% real_imag = zeros(1,36);
% 
% for level = 1:6
%     for tree2 = 1:2
%         for band = 1:3
%             count = count+1;
%             real_imag(count) = nor{level}{1}{tree2}{band}/nor{level}{2}{tree2}{band};
%         end
%     end
% end
% 
% bar(real_imag);
% grid on
% set(gca,'XTick',1:6:length(real_imag));
% set(gca,'YTick',0:0.1:1.5);
% ylim([0.6,1.5]);
% title({'DT-CWT: Ratio of Real and Imaginary Frames norm.','6 bands(Directions) in each level. 6 Levels.'},...
%     'FontSize',18);

%%

% x = -5:0.01:5;
% y = quantization(x, 1, 0, 1);
% plot(x,y)
% set(gca,'YTick', -6:1:6);
% grid on

%% test filter1d, filter2d, ffilter class

% x = [1, zeros(1,31)];
% x = rand(64);
% 
% tfilter = Daubechies8_1d;
% low = tfilter(1);
% high = tfilter(2);
% 
% flow = convert_ffilter(low, length(x));
% fhigh = convert_ffilter(high, length(x));

% plot_ffilter(flow)
% figure;plot_ffilter(fhigh)
% ffilter = [flow, fhigh];

% w1 = d2tconv_fir(x, low.filter, low.start_pt, high.filter, high.start_pt );
% 
% xf = fft2(x);
% wf = fconv(flow,xf, 2);
% wf = fconv(fhigh,wf, 1);
% w2 = ifft2(wf);
% 
% err = sum(sum(abs(w1-w2)))

% f2d = filter2d(low,low);
% w1 = analysis2d(x, f2d);
% 
% xf = fft2(x);
% wf = fanalysis(flow, xf, 1, 2);
% wf = fanalysis(flow, wf, 2, 2);
% w2 = ifft2(wf);
% 
% err = sum(sum(abs(w1-w2)))

% num_zeros = length(x)-length(low.filter);
% ffilterlow = [low.filter, zeros(1,num_zeros)];
% ffilterlow = circshift2d(ffilterlow, 0, low.start_pt);
% ffilterlow = fft(ffilterlow);
% 
% num_zeros = length(x)-length(high.filter);
% ffilterhigh = [high.filter, zeros(1,num_zeros)];
% ffilterhigh = circshift2d(ffilterhigh, 0, high.start_pt);
% ffilterhigh = fft(ffilterhigh);
% 
% ffilter = cell(1,2);
% ffilter{1} = ffilterlow;
% ffilter{2} = ffilterhigh;
% 
% w = cell(1,2);
% w{1} = fanalysis1d(x, ffilterlow);
% w{2} = fanalysis1d(x, ffilterhigh);
% 
% y = fsynthesis1d(w, ffilter);
% 
% err = max(abs(x-y))

% plot(fftshift(abs(fft(ffilter))));
% grid on;

% tconv1 = ifft(fconv);
% tconv2 = d1tconv(x, low.filter, tfilter(1).start_pt );
%  
% err = max(abs(tconv1 - tconv2))


% w = fFramelet1d(x, 3, ffilter);
% y = fiFramelet1d(w, 3, ffilter);

% err = max(abs(x-y))


%% 

% x = 1:24;

% fb = Daubechies8_1d;
% low = fb(1);
% hi = fb(2);
% 
% low = checkfilter(low,3);
% 
% % for i = 1:500
% 
%     w = analysis_old(low, x, 2, 1);
%     w2 = analysis(low, x, 2, 1);
% 
% % end
% 
% err = max(max(abs(w-w2)))

%%

% Ssig_est = 0:0.001:3;
% 
% Nsig = 1;
% 
% lambda1 = 0.7;
% lambda2 = 1;
% Ssig_tmp1 = Ssig_est.*(Ssig_est>lambda2*Nsig);
% 
% b = (2*lambda2+lambda1)/Nsig/(lambda2-lambda1)^2;
% a = -(lambda1+lambda2)/Nsig^2/(lambda2-lambda1)^3;
% Ssig_tmp2 = a*(Ssig_est - lambda1*Nsig).^3 + b*(Ssig_est - lambda1*Nsig).^2;
% Ssig_tmp2 = Ssig_tmp2 .* (Ssig_est<=lambda2*Nsig) .* (Ssig_est > lambda1*Nsig);
% Ssig = Ssig_tmp1 + Ssig_tmp2;
% Ssig = max(Ssig, eps);
% 
% plot(Ssig_est, Ssig)
% grid on

%%

% [X, Y] = meshgrid(-5:0.1:5);
% T = 0.5;
% 
% W = bishrink(X, Y, T);
% surf(X, Y, W)
% xlabel('y1', 'FontSize',18);
% ylabel('y2', 'FontSize',18);
% title('Exponential Thresholding Function');
% % tightfig;

%%
% Ssig_est = 0:0.01:2;
% Nsig = 1;
% 
% lambda1 = 0.2834;
% lambda2 = 1.0;
% alpha = 0.45;
% Ssig_tmp1 = Ssig_est.*(Ssig_est>lambda2*Nsig);
% Ssig_tmp2 = (Ssig_est.^2-lambda1^2*Nsig.^2).*(Ssig_est<=lambda2*Nsig);
% Ssig_tmp2 = Ssig_tmp2.*(Ssig_tmp2>0);
% Ssig_tmp2 = Ssig_tmp2.^alpha * (lambda2/(lambda2^2-lambda1^2)^alpha);
% Ssig = Ssig_tmp1 + Ssig_tmp2;
% Ssig = max(Ssig, eps);
% 
% plot(Ssig_est, Ssig)
% grid on
%%

% Nsig = 100;
% Wsig = 0:0.1:Nsig^2*4;
% Ssig_est = sqrt(max(Wsig - Nsig.^2, eps));
% Wsig = Wsig/Nsig^2;
% Ssig_est = Ssig_est/Nsig;
% 
% lambda = log(Nsig/5)/log(20);
% 
% p1_100 = -0.19964;
% p2_100 = 0.91041;
% p3_100 = -1.0431;
% p4_100 = 0.29835;
% p5_100 = 0.088331;
% yt_100 = p1_100*Wsig.^4 + p2_100*Wsig.^3 +p3_100*Wsig.^2 + p4_100*Wsig +p5_100;
% 
% p1_5 = -0.024297;
% p2_5 = 0.035368;
% p3_5 = 0.23881;
% p4_5 = -0.32861;
% p5_5 = 0.48456;
% yt_5 = p1_5*Wsig.^4 + p2_5*Wsig.^3 +p3_5*Wsig.^2 + p4_5*Wsig +p5_5;
% 
% Ssig_tmp1 = Ssig_est.*(Wsig>=2.4);
% Ssig_tmp2 = lambda*yt_100 + (1-lambda)*yt_5;
% Ssig_tmp2 = Ssig_tmp2.*sqrt(Wsig).*(Wsig<2.4);
% % Ssig_tmp2 = Ssig_tmp2.*(Wsig>1.4);
% Ssig = Ssig_tmp1 + Ssig_tmp2;
% % Ssig = Ssig*Nsig;
% Ssig = max(Ssig, eps);
% 
% 
% plot(Wsig, Ssig); grid on

%%

% title('Conditional Expectation $E(\sigma|\sigma_y)$, $\sigma_n=5$', 'Interpreter', 'LaTex')
% legend('Fitted', 'Calculated','Experiment(Lena)');

%%

Wsig = 0:0.01:6;
Nsig = 1;

Wsig = Wsig/Nsig^2;
Ssig_est = sqrt(max(eps, Wsig-1));

lambda = 1;

yt_5 = SigmaBM(Wsig, 5);
yt_100 = SigmaBM(Wsig, 100);

Ssig_tmp1 = Ssig_est.*(Wsig>=2.7);
Ssig_tmp2 = lambda*yt_100 + (1-lambda)*yt_5;
Ssig_tmp2 = Ssig_tmp2.*(Wsig<2.7);
%                 Ssig_tmp2 = Ssig_tmp2.*(Wsig>1.4);
Ssig = Ssig_tmp1 + Ssig_tmp2;
% Ssig = Ssig*Nsig;
Ssig = max(Ssig, eps);
plot(Wsig, Ssig.^2, 'g'); grid on; hold on

%%


Ssig_est = sqrt(max(eps, Wsig-1));

lambda1 = 0.4;  %0.4
lambda2 = 1.2;  %1.2
Ssig_tmp1 = Ssig_est.*(Ssig_est>lambda2*Nsig);

b = (2*lambda2+lambda1)/Nsig/(lambda2-lambda1)^2;
a = -(lambda1+lambda2)/Nsig^2/(lambda2-lambda1)^3;
Ssig_tmp2 = a*(Ssig_est - lambda1*Nsig).^3 + b*(Ssig_est - lambda1*Nsig).^2;
Ssig_tmp2 = Ssig_tmp2 .* (Ssig_est<=lambda2*Nsig) .* (Ssig_est > lambda1*Nsig);
Ssig = Ssig_tmp1 + Ssig_tmp2;
Ssig = max(Ssig, eps);


plot(Wsig, Ssig.^2, 'b'); grid on







	

