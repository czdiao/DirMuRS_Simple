%% Set Home Path and Add to Path
clear;
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% OLD_CODE = [HOME_PATH 'old_code'];
% path(pathdef);
% addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));

%%
% clear;

% x = rand(1024);
% 
% tfilter = Daubechies8_1d;
% low = tfilter(1);
% high = tfilter(2);

% af = filter2d(low, low);
% wt = analysis2d(x, af);

% flow = convert_ffilter(low, length(x));
% fhigh = convert_ffilter(high, length(x));
% Ff = [flow, fhigh];
% 
% 
% w1 = low.analysis(x, 2, 1);
% 
% xf = fft2(x);
% yf = flow.fanalysis(xf, 2, 1);
% w2 = ifft2(yf);
% 
% err = sum(sum(abs(w1-w2)))

%%

% w = cell(1,2);
% w{1} = analysis(low, x, 2, 1);
% w{2} = analysis(high, x, 2, 1);
% 
% y = synthesis(tfilter, w, 2, 1);
% 
% err = sum(abs(x-y))

%% 
% NFilter = 2;
% tmp = cell(1, 2);
% for i = 1:NFilter %col
%     tmp{i} = fanalysis(Ff(i), xf, 2, 1);
% end
% 
% w = cell(1, NFilter);
% for i = 1:NFilter %row
%     w{i} = cell(1, NFilter);
%     for j = 1:NFilter
%         w{i}{j} = fanalysis(Ff(j), tmp{i},2,2);
%     end
% end
% 
% for i = 1:2
%     tmp{i} = fsynthesis(Ff, w{i}, 2, 2);
% end
% 
% yf = fsynthesis(Ff, tmp, 2, 1);
% y = ifft2(yf);
% 
% err = sum(sum(abs(x-y)))

%%

% t2=-2;
% t1=2.1;
% 
% P = [-t2, -t1, t1+t2-1, 0, 1];
% pp = [t2, t1+t2, 1, 1];
% 
% az = FejerRieszReal(pp);
% az = az.convfilter(filter1d([0.5, 0.5], 0));
% 
% a2 = az.convfilter(az.conjflip);
% 
% xi = -pi:0.001:pi;
% x = sin(xi/2).^2;
% 
% Q = [t2, -2*t2 - t1, 1];
% uz = FejerRieszReal(Q);
% uz = uz.freqshift(pi);
% uz = Real(uz);
% uz = uz.convfilter(filter1d([-1/4, 1/2, -1/4], -1));
% 
% u2 = uz.convfilter(uz.conjflip);
% yu = u2.FreqResponse(xi);
% 
% 
% y1 = polyval(P, x);
% 
% plot(xi, abs(1-y1-yu))
% xlim([-pi, pi]); grid on
% y2 = a2.FreqResponse(xi);
% 
% err = abs(y1-y2);
% 
% plot(xi, y1, 'r*', xi, abs(y2), 'g-', xi, err, 'bo')

% bz = FejerRieszReal(P);
% 
% e = az + (-1).*bz;
% 
% a2 = az.convfilter(az.conjflip);
% af = a2.convert_ffilter(1024);
% af.plot_ffilter

%%

% t1 = -2;
% t2 = 2.5;
% 
% [az, uz] = InitialLowpass(t1, t2);
% 
% c1 = sqrt(2)/2; d1 = sqrt(2)/2;
% % c1 = 0; d1 = 0;
% [b1, b2] = InitialHighpass(uz, c1, d1);
% 
% I = sqrt(-1);
% 
% bp = b1 + I.* b2;

% b2 = bp.convfilter(bp.conjflip);

% xi = -pi:0.01:pi;
% y = b2.FreqResponse(xi);
% plot(xi, abs(y))
% xlim([-pi, pi]); grid on

%%
% [FS_fb, fb] = DualTree_FilterBank_Zhao;
% 
% FS_fb{1}(1) = az;
% FS_fb{1}(2) = sqrt(2).* b1;
% 
% FS_fb{2}(1) = az;
% FS_fb{2}(1).start_pt = az.start_pt+1;
% FS_fb{2}(2) = sqrt(2).* b2;
% 
% x = rand(512);
% w = DualTree2d(x, 4, FS_fb, fb);
% y = iDualTree2d(w, 4, FS_fb, fb);
% 
% err = max(max(abs(x-y)))

% bp.fplot


% fbtest(4) = sqrt(2).* b1;
% fbtest(3) = sqrt(2).* b2;
% fbtest(2) = FS_fb{2}(1);
% fbtest(1) = FS_fb{1}(1);

% fbtest(4) = FS_fb{2}(2);
% fbtest(3) = FS_fb{1}(2);
% fbtest(2) = FS_fb{2}(1);
% fbtest(1) = FS_fb{1}(1);

% fbtest = 1/sqrt(2) .* fbtest;
% 
% w = Framelet2d(x, 2, fbtest);
% y = iFramelet2d(w, 2, fbtest);
% 
% err = max(max(abs(x-y)))

%% Test freqfilter2d class

% I = sqrt(-1);
% ff(2) = freqfilter1d;
% ff(1).ffilter = randn(1,512) + I* randn(1, 512);
% ff(2).ffilter = randn(1,512) + I* randn(1, 512);
% ff2d = freqfilter2d(ff(1), ff(2));

ff = Daubechies8_1d;
ff = ff.convert_ffilter(512);

ff2d = freqfilter2d(ff, ff);

% ff2d_new = ff2d.filterdownsample(32,32);
% ff2d_new.plot_ffilter
% for i = 1:4
% figure;ff2d(i).plot_ffilter;
% end

% tf(2) = filter1d;
% tf(1).filter = zeros(1, 512);
% tf(1).filter(1) = 1;
% tf(1).start_pt = 0;
% tf(2) = tf(1);

% ff = tf.convert_ffilter(512);
% ff2d = freqfilter2d(ff(1), ff(2));

% x = randn(128);
x = double(imread('Lena512.png'));
% x = x-128;
% v = 1:8;
% x = [v; v+8; v+16; v+24; v+32; v+40; v+48; v+56];
w = fft2(x);

coef = cell(1,4);

coef{1} = ff2d(1).fanalysis(w, 2, 2);
coef{2} = ff2d(2).fanalysis(w, 2, 2);
coef{3} = ff2d(3).fanalysis(w, 2, 2);
coef{4} = ff2d(4).fanalysis(w, 2, 2);

yf = ff2d.fsynthesis(coef, 2, 2);
yf = ifft2(yf);

err = max(max(abs(yf-x)))

tmp = ff2d(1).ffilter;
tmp = ifft2(tmp);
tmp = tmp.* (abs(tmp)>1e-10);




