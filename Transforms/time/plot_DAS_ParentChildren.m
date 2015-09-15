% Plot Parent Children Relation
clear;

nlevel = 4;     % level of decomposition
L = 8*2^nlevel; % size of image

x = zeros(L,L);


% [FS_filter1d, FilterBank1d] = DualTree_FilterBank_Selesnick;
[FS_filter1d, FilterBank1d] = DualTree_FilterBank_test;


w = DualTree2d(x, nlevel, FS_filter1d, FilterBank1d);

J = 3;  % level to plot DAS
N = L/2^J;  % center position



d2 = 1;
d1 = 2;
nband = 1;
%%
subplot_tight(2,2,1);
w{J}{d1}{d2}{nband}(N/2-1, N/2-1) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J}{d1}{d2}{nband}(N/2-1, N/2-1) = 0;
surf(y1); hold on;

w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
surf(y1);
xlim([1,L]);
ylim([1,L]);
view(0, 90)

%%
subplot_tight(2,2,2);
w{J}{d1}{d2}{nband}(N/2-1, N/2) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J}{d1}{d2}{nband}(N/2-1, N/2) = 0;
surf(y1); hold on;

w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
surf(y1);
xlim([1,L]);
ylim([1,L]);
view(0, 90)

%%
subplot_tight(2,2,3);
w{J}{d1}{d2}{nband}(N/2, N/2-1) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J}{d1}{d2}{nband}(N/2, N/2-1) = 0;
surf(y1); hold on;

w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
surf(y1);
xlim([1,L]);
ylim([1,L]);
view(0, 90)

%%
subplot_tight(2,2,4);
w{J}{d1}{d2}{nband}(N/2, N/2) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J}{d1}{d2}{nband}(N/2, N/2) = 0;
surf(y1); hold on;

w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
y1 = iDualTree2d_new(w,nlevel, FS_filter1d, FilterBank1d);
w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
surf(y1);
xlim([1,L]);
ylim([1,L]);
view(0, 90)


