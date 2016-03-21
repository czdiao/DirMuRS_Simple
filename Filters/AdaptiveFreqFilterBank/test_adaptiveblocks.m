clear;

%%
% % 1d freq filter bank
% fb = CTF3_FilterBank_freq(512);
% fb = CTF6_FilterBank_freq(1024);
% fb = CTF13_FilterBank_freq(256);
% fb = Daubechies8_1d;
% fb = fb.convert_ffilter(1024);
% fb = Tree1Filter1d;
% fb = fb.convert_ffilter(1024);
% figure;
% fb.plot_ffilter
% figure;
% fb.checkPR

% % 2d freq filter bank
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
% fb2d = CTFblock_FilterBank_freq2D(512);
% fb2d = CTFAdaptiveTest_FilterBank_freq2D( 256 );
% fb2d = CTF13block_FilterBank_freq2D(128);
fb2d = CTF13AdaptiveTest_FilterBank_freq2D(256);
fb2d.plot_ffilter
% fb2d.checkPR

% img = 'Barbara512.png';
% x = double(imread(img));
% Nsig = 5;
% rng(0,'v4');
% n = Nsig*randn(size(x));
% % x = x + n;

% fb2d(2:end) = FFBEnergyCal(fb2d(2:end), x);
% ffbindex = FFBindex(12, 12, fb2d(2:end));
% figure;ShowImage((ffbindex.EnergyMatrix))
% figure;ShowImage(ffbindex.Norm2Matrix);

% Group = FBGroup(ffbindex);
% fb2d_new = FBCombineGroup(Group, fb2d(2:end));
% fb2d_new = [fb2d(1), fb2d_new];
% fb2d_new.plot_ffilter

%%
img = 'Boat.png';
x = double(imread(img));
Nsig = 5;
% rng(0,'v4');
% n = Nsig*randn(size(x));
% % x = x + n;
% 
% figure
hold on;
xf = plot_freq(x);
% % xf2 = plot_freq(x+n);

%% Plot Frame Norms

% fb2d = CTF6_FilterBank_freq2D(1024);
% 
% [FS_filter1d, fb1d] = DualTree_FilterBank_Zhao;
% %To split lowpass
% [u1, u2] = SplitLowOrig;
% u_low = [u1, u2];
% %To split highpass
% [u1, u2] = SplitHaar;
% u_hi = [u1, u2];
% % u_hi = Daubechies8_1d;
% 
% 
% 
% % dtwavelet = DualTreeSplitHighLow2D(FS_filter1d, fb1d, u_hi, u_low);
% dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
% 
% % dtwavelet = fFrameletTransform2D(fb);
% nL = 5;     % decomposition levels
% dtwavelet.level_norm = nL;
% dtwavelet.nlevel = nL;
% dtwavelet.nor = dtwavelet.CalFilterNorm;
% 
% figure; plotnorm(dtwavelet)
% title('Frame L2 norm of TPCTF6');

%% Test mixed sampling rate PR

% fb2d = CTF6_FilterBank_freq2D(512);

% fb = Haar1d;
% fb = fb.convert_ffilter(512);
% fb2d = freqfilter2d(fb,fb);
% for i = 2:4
%     fb2d(i).rate = 1;
% end
% fb.plot_ffilter
% fb.checkPR

% len = length(fb2d);
% for i = 2:len
%     fb2d(i).rate = 1;
% end
% 
% nL = 5;
% dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
% dtwavelet.nlevel = nL;
% % 
% x = randn(512);
% dtwavelet.coeff = dtwavelet.decomposition(x);
% y = dtwavelet.reconstruction;
% err = max(max(abs(x-y)))

% f = fb2d(2);
% xf = fft2(x);
% 
% y1{1} = f.fanalysis(xf);
% y1 = f.fsynthesis(y1);
% 
% f.rate = 1;
% y2{1} = f.fanalysis(xf);
% y2 = f.fsynthesis(y2);








