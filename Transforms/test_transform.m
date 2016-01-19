%% Set Home Path and Add to Path
clear;
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
OLD_CODE = [HOME_PATH 'old_code'];
path(pathdef);
addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));


%%

clear;
% x = rand(512);
% imgName    = '1.2.08.tiff';
% x = double(imread(imgName));
% x(511,:) = x(510,:);
% x(512,:) = x(510,:);

% tfilter = Haar1d;
% tfilter = Daubechies8_1d;
% low = tfilter(1);
% high = tfilter(2);

% flow = convert_ffilter(low, length(x));
% fhigh = convert_ffilter(high, length(x));
% Ff = [flow, fhigh];

% fhigh2 = flow.fCQF;
% err = max(abs(fhigh.ffilter - fhigh2.ffilter))



% fx = fft2(x);
% w = fFramelet2d_new(fx, 3, Ff);
% fy = ifFramelet2d_new(w, 3, Ff);
% % [L, H] = d2fanalysis(fx, 2, Ff, Ff);
% % w = [L, H];
% % fy = d2fsynthesis(w, 2, Ff, Ff);
%
% y = ifft2(fy);
%
% err = max(max(abs(x-y)))

% for i = 1:200
% w = Framelet1d_new(x, 3, tfilter);
% y = iFramelet1d_new(w, 3, tfilter);
% end
% err = sum(abs(x-y))

% for i = 1:20
% w = Framelet2d_new(x, 3, tfilter, tfilter);
% y = iFramelet2d_new(w, 3, tfilter, tfilter);
% end
% 
% % [L, H] = d2tanalysis(x,2,tfilter, tfilter);
% % w = [L, H];
% %
% % y = d2tsynthesis(w, 2, tfilter, tfilter);
% %
% err = sum(sum(abs(x-y)))

%%

% load filters

% To split lowpass
% [u1, u2] = SplitLowOrig;
% u_low = [u1, u2];
% u_low = u_low.freqshift(pi/4);

% To split highpass
% [u1, u2] = SplitHaar;
% u_hi = [u1, u2];
% u_hi = u_hi.freqshift(pi/3);

% [FS_fb, fb] = DualTree_FilterBank_Zhao;

% tmp_fb = FilterBank1d{1};
% w = DualTree2d_SplitHighLowComplex(x, 2, FS_fb, fb, u_hi, u_low);
% y = iDualTree2d_SplitHighLowComplex(w, 2, FS_fb, fb, u_hi, u_low);


% w = Framelet2d_new(x, 1, FilterBank1d{1}, FilterBank1d{1});
% y = iFramelet2d_new(w, 1, FilterBank1d{1}, FilterBank1d{1});
% 
% w = Framelet1d_new(x, 3, tmp_fb);
% y = iFramelet1d_new(w, 3, tmp_fb);

% err = max(max(abs(x-y)))

% m = 2; n = 2;
% [L, H] = d2tanalysis(x, 2, FS_filter1d{m}, FS_filter1d{n});
% [L, H] = d2tanalysis(L, 2, FS_filter1d{m}, FS_filter1d{n});
% [L, H] = d2tanalysis(x, 2, FilterBank1d{m}, FilterBank1d{n});


%%

% [FS_filter1d,FilterBank1d] = DualTree_FilterBank_freq(length(x));
% 
% w = fDualTree2d_SplitHighLow(x, 5, FS_filter1d, FilterBank1d);
% y = ifDualTree2d_SplitHighLow(w, 5, FS_filter1d, FilterBank1d);
% 
% err = max(max(abs(x-y)))


%%
% for i = 1:20
% [C,L] = wavedec2(x,3,'db8');
% y = waverec2(C,L,'db8');
% end
% 
% err = max(max(abs(x-y)))

%%

% [FSFB, FB] = DualTree_FilterBank_freq_cpt(length(x));
% w = fDualTree2d(x, 6, FSFB, FB);
% y = ifDualTree2d(w, 6, FSFB, FB);
% y = real(y);
% 
% % w = fFramelet2d_new(x, 3, Ffilter, Ffilter);
% % y = ifFramelet2d_new(w, 3, Ffilter, Ffilter);
% 
% err = max(max(abs(x-y)))

%%

% load('nor_DT_freq.mat', 'nor');
% % nor1 = nor;
% % 
% % load('nor_DT_freq_cpt.mat', 'nor');
% % nor2 = nor;
% 
% for j = 4
%     nor{j}{1}{1}
% %     nor2{j}{1}{1}
% end


%%
% ShowImage(x);
% 
% x = symrotate(x,45);
% L = length(x); % length of the original image.
% buffer_size = L/2;
% x = symext(x,buffer_size);

% y = log(abs(fftshift(fft2(x))));

% hist(y(:), 100)
% ShowImage(y)

% x = symrotate(x,45);
% y = log(abs(fftshift(fft2(x))));
% figure; ShowImage(y)
% colormap(jet)

% ind = buffer_size+1 : buffer_size+L;
% y = y(ind,ind);
% figure;
% ShowImage(x)

% [FS_filter1d, FilterBank1d] = DualTree_FilterBank_Zhao;
% 
% nlevel = 3;
% [u1, u2] = SplitULen3(-0.2, pi);
% u_hi = [u1, u2];
% 
% [u1, u2] = SplitULen3(0.2, 1);
% u_low = [u1, u2];
% 
% w = DualTree2d_SplitHighLowComplex(x, nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
% y = iDualTree2d_SplitHighLowComplex(w, nlevel, FS_filter1d, FilterBank1d, u_hi, u_low);
% 
% err = max(max(abs(x-y)))

% x = double(imread('Lena512.png'));
% [FS_fb, fb] = DualTree_FilterBank_Zhao;
% w = DualTree2d(x, 5, FS_fb, fb);
% 
% wcoeff1 = WaveletData2D(w, 'DualTree');
% wcoeff2 = 2.*wcoeff1;
% 
% 
% w1 = wcoeff1.coeff;
% w2 = wcoeff2.coeff;
% y1 = iDualTree2d(w1, 5, FS_fb, fb);
% y2 = iDualTree2d(w2, 5, FS_fb, fb);


x = double(imread('Lena512.png'));
fb = Daubechies8_1d;

w = Framelet2d(x, 5, fb);

wcoeff1 = WaveletData2D(w, 'Framelet');
wcoeff2 = 2.*wcoeff1;


w1 = wcoeff1.coeff;
w2 = wcoeff2.coeff;
y1 = iFramelet2d(w1, 5, fb);
y2 = iFramelet2d(w2, 5, fb);


n1 = sqrt(sum(sum(x.^2)))

n2 = wcoeff1.norm(2)









