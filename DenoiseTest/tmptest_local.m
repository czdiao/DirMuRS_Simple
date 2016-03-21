clear;

%%
imgName    = 'Barbara512.png';
s1 = double(imread(imgName));

imgName    = 'Lena512.png';
s2 = double(imread(imgName));

imgName    = 'fingerprint.png';
s3 = double(imread(imgName));

imgName    = 'Boat.png';
s4 = double(imread(imgName));

% s = [s1, s2; s3, s4];
s = s1;


%% Transform
% imgName    = 'Barbara512.png';
% imgName    = 'fingerprint.png';
% imgName    = '1.2.08.tiff';
% s = double(imread(imgName));
% s = randn(512);

[FS_filter1d, fb1d] = DualTree_FilterBank_Zhao;

%%To split lowpass
[u1, u2] = SplitLowOrig;
u_low = [u1, u2];

%%To split highpass
[u1, u2] = SplitHaar;
u_hi = [u1, u2];

nL = 5;     % decomposition levels
dtwavelet = DualTreeSplitHigh2D(FS_filter1d, fb1d, u_hi);
dtwavelet.level_norm = nL;
dtwavelet.nlevel = nL;
dtwavelet.nor = dtwavelet.CalFilterNorm;

WT = dtwavelet;

WT.coeff = WT.decomposition(s);
WT_normal = WT;
WT_normal.coeff = WT_normal.normcoeff;

%% Data Analysis

% select by l2 energy distribution
alpha = 0.8;
[d1, d2] = size(s);

p = zeros(size(s));
VARIANCE = zeros(size(s));
parfor i = 1:d1
    for j = 1:d2
        v = WT_normal.getlocalcoeff(i,j);
        v = v(:).^2;
        v = sort(v);
        v = v(end:(-1):1);
        total_l2 = sum(v);
        tmp = 0;
        len = length(v);
        
%         VARIANCE(i,j) = var(v);
        
        for k = 1:len
            tmp = tmp+v(k);
            if tmp > total_l2*alpha
                p(i,j) = k/len;
                break
            end
        end
        
    end
end

% figure; subplot(1,2, 1); ShowImage(s);
% 
% vlog = log(VARIANCE);
% subplot(1,2,2); ShowImage(vlog);title('ln(variance)')

figure; subplot(1,2, 1); ShowImage(s);
subplot(1,2,2); ShowImage(p);title('0.8 Energy distribution')


% pp = p(:);
% figure; hist(pp, 50)

%%


% I = p<0.08;
% tt = s.*I;
% figure; ShowImage(tt)




