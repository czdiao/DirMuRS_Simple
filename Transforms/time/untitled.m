% clear;

N = 512;
fb2d = CTF6_FilterBank_freq2D(N);
nL = 5;   %4;     % decomposition levels
dtwavelet = TPCTF2D(fb2d);  % this is for freqfilter2d nonseparable
dtwavelet.level_norm = nL;
dtwavelet.nlevel = nL;

% x = randn(N);
% tic;
% dtwavelet.coeff = dtwavelet.decomposition_undecimated(x);
% toc
% y = dtwavelet.reconstruction_undecimated;
% err = max(max(abs(x-y)))

% tic;
% fr = dtwavelet.getFrames(N);
% toc

%%
% tic;
% x = zeros(N);
% 
% wzero = dtwavelet.decomposition(x);
% 
% err = [];
% for j = 1:nL
%     nb = length(wzero{j});
%     for ib = 1:nb
%         w = wzero;
%         w{j}{ib}(1,1) = 1;
%         dtwavelet.coeff = w;
%         y = dtwavelet.reconstruction;
%         y = circshift2d(y, -1, -1);
%         tmp = abs(fr{j}{ib} - y);
%         tmp = norm(tmp, 'fro');
%         err = [err, tmp];
%     end
% end
% toc
%%
% fr_real = dtwavelet.getFramesImag(N);

tic;
[Cwr, Cwi] = dtwavelet.CalCovMatrix(N, 5);
% [fr_real, fr_imag] = dtwavelet.getFramesReal(N);
% fr= dtwavelet.getFrames(N);
toc
%%
% sigmaN = 10;
% zhaor = Cw{1}{1};
% zhaoi = Cw{2}{1};
% 
% nL = 4;
% for j = 1:nL
%     for ib = 1:32
%         tmpr{j}{ib} = zhaor{j}{ib}/sigmaN^2;
%         tmpi{j}{ib} = zhaoi{j}{ib}/sigmaN^2;
%     end
% end


%%
% coeff = WT.getCoeffReal;
% coeffr = coeff{1};


%%









