%% Set Home Path and Add to Path
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% addpath(genpath(HOME_PATH));

%%
clear;

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

x{1} = 1:8;

f = filter1d;
f.filter = [2,3,6,5];

y1 = f.synthesis(x,2,2);
y2 = upfirdn









