clear;

ker = fspecial('gaussian', 9, 2);

% fb2d = Angular_FilterBank_freq2D( linspace(pi/8,6*pi/8,3), 8, 512 );
fb2d  = GenAngular_FB_freq2D_gaussian( ker, 256 );


fb2d.plot_ffilter;
fb2d.checkPR(1);

% tmp = fb2d(18:end);
% tmp(1).plot_ffilter
% tmp.plot_ffilter
% tmp(1).plot_ffilter

% a = fb2d(1);
% for i = 2:length(fb2d)
%     a = add(a, fb2d(i));
% end

WT = TPCTF2D(fb2d);
WT.nlevel = 1;

% WT.plot_DAS_freq(1);

x = randn(512);

WT.coeff = WT.decomposition(x);
y = WT.reconstruction;

err = max(max(abs(x-y)))

