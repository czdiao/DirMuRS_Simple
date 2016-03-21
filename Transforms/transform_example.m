%% Examples of Transforms
%   For each transform, test PR, plot DAS in time and freq domain.
%
%   Chenzhe
%

%% Eg1. TPCTF2D
% Test fFrameletTransform2D class
% clear;
% s = randn(512);
% fb = CTF3_FilterBank_freq(128);
% fb = Daubechies8_1d;
% fb = fb.convert_ffilter(1024);
% fb = Tree1Filter1d;
% fb = fb.convert_ffilter(1024);

% WT = fFrameletTransform2D(fb);
% WT.nlevel = 5;
% WT.coeff = WT.decomposition(s);
% 
% y = WT.reconstruction();
% err = max(max(abs(y-s)))
% 
% WT.level_norm = 5;
% WT.nor =WT.CalFilterNorm;
% WT.plotnorm;
% 
% WT.plot_DAS_freq(1);
% WT.plot_DAS_time(3);

% fb2d = freqfilter2d(fb, fb);
% fb2d.checkPR



%% Section 2 Title
clear;
% s = randn(256);
% fb = CTF3_FilterBank_freq(512);
% fb = CTF6_FilterBank_freq(1024);
% fb = CTF12_FilterBank_freq(1024);
% fb = Daubechies8_1d;
% fb = fb.convert_ffilter(1024);
% fb = Tree1Filter1d;
% fb = fb.convert_ffilter(1024);
% figure;
% fb.plot_ffilter
% figure;
% fb.checkPR


% fb = Haar1d;
% fb = fb.convert_ffilter(256);
% fb2d = freqfilter2d(fb,fb);
% for i = 2:4
%     fb2d(i).rate = 1;
% end
% fb.plot_ffilter
% fb.checkPR
% fb2d = freqfilter2d(fb, fb);
% fb2d = CTF6_FilterBank_freq2D(256);
fb2d = CTFblock_FilterBank_freq2D(512);
% fb2d = CTFAdaptiveTest_FilterBank_freq2D( 256 );
% fb2d.plot_ffilter
% fb2d.checkPR

img = 'Barbara512.png';
x = double(imread(img));
% Nsig = 5;
% rng(0,'v4');
% n = Nsig*randn(size(x));
% % x = x + n;

fb2d(2:end) = FFBEnergyCal(fb2d(2:end), x);
ffbindex = FFBindex(12, 12, fb2d(2:end));
figure;ShowImage((ffbindex.EnergyMatrix))
figure;ShowImage(ffbindex.Norm2Matrix);

% Group = FBGroup(ffbindex);
% fb2d_new = FBCombineGroup(Group, fb2d(2:end));
% fb2d_new = [fb2d(1), fb2d_new];
% fb2d_new.plot_ffilter

% order = [1, 3:2:129];
% fb2d_new = fb2d(order);
% fb2d_new.plot_ffilter

% WT = TPCTF2D(fb2d);
% WT.nlevel = 5;
% WT.coeff = WT.decomposition(s);
% 
% y = WT.reconstruction();
% err = max(max(abs(y-s)))
% 
% WT.level_norm = 3;
% WT.nor =WT.CalFilterNorm([256, 256]);
% figure;WT.plotnorm

% WT.plot_DAS_freq(2);
% WT.plot_DAS_time(3);




%% Test for short directional filters, by CTF3
% clear;
% fb = CTF3_FilterBank_freq(8);
% fb2d = freqfilter2d(fb, fb);
% len = length(fb2d);
% % fb.plot_ffilter;
% 
% tmp = cell(3,3);
% figure;
% for i = 1:len
%     tf = zeros(10, 10);
%     tf(2:9, 2:9) = fftshift(ifft2(fb2d(i).ffilter));
%     tmp{i} = [real(tf); imag(tf)];
% end
% 
% A = cell2mat(tmp);
% ShowImage(A'); hold on;
% view(0, 90)
% daspect([90, 90, 1])
% title('CTF3 8x8 directional filters');

%%

% img = 'Barbara512.png';
% x = double(imread(img));
% Nsig = 5;
% rng(0,'v4');
% n = Nsig*randn(size(x));
% % x = x + n;
% 
% figure
% % hold on;
% xf = plot_freq(x);
% % xf2 = plot_freq(x+n);













