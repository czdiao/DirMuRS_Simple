%% Old code (using old transforms), cannot be used anymore.


clear;

%% Add Path
HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
addpath(genpath(HOME_PATH));

%% Load Noise
% sigmaN = [10, 15, 20, 25, 30];
sigmaN = [5, 10, 25, 40, 50, 80, 100];
len = length(sigmaN);
% load('noise512_TestThresholding.mat');
load('noise512.mat','noise512');

%% Load Image
imgName    = 'Lena512.png';
x = double(imread(imgName));

%% Load Filter
filter = Daubechies8Filter2d;
load('nor_daubechies8.mat', 'nor');

%%
i = 3;  % Choose noise level
n = noise512{i};
% s = x + n;
s = x;

%% Decompose
L = length(s); % length of the original image.
buffer_size = L/2;
s = symext(s,buffer_size);

nlevel = 5;
W = Framelet2d(s, nlevel, filter);
W = normcoef(W,nlevel,nor);

T = cell(1, nlevel-1);
R = zeros(L,L);

for scale = 1:nlevel-1
    L = L/2;
    buffer_size = buffer_size/2;
    num_hipass = length(W{scale});
    T{scale} = cell(1,num_hipass);
    
    for l  = 1:num_hipass
        Y_coef = W{scale}{l};
        Y_parent = W{scale+1}{l};
        
        %extend parent matrix to make it the same size
        Y_parent = expand(Y_parent);
        %threshold value estimation
        T{scale}{l} = sqrt(3)*abs(Y_coef)./sqrt(Y_coef.^2+Y_parent.^2);
        T{scale}{l} = T{scale}{l}.*((Y_coef.^2+Y_parent.^2)~=0);
        
        ind = buffer_size+1 : buffer_size+L;
        T{scale}{l} = T{scale}{l}(ind,ind);
        
    end
    R(L+1:2*L, 1:L) = T{scale}{1};
    R(1:L, L+1:2*L) = T{scale}{2};
    R(L+1:2*L, L+1:2*L) = T{scale}{3};

end

ShowImage(R)
% surf(R); xlim([0,512]);ylim([0,512])
[M, N] = size(R);
set(gca,'XTick',1:32:N);
set(gca,'YTick',1:32:M);
tightfig



