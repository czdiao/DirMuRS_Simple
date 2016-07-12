%% Add Path
clear;
% HOME_PATH = 'E:/Dropbox/Research/DirMuRS_Simple/';
% % HOME_PATH = '/Users/chenzhe/Dropbox/Research/DirMuRS_Simple/';
% OLD_CODE = [HOME_PATH 'old_code'];
% path(pathdef);
% addpath(genpath(HOME_PATH)); rmpath(genpath(OLD_CODE));


%% Input Filters
% [FS_fb, fb] = DualTree_FilterBank_Selesnick;
[FS_fb, fb] = DualTree_FilterBank_Zhao;


[u1, u2] = SplitLowOrig;
u_low = [u1, u2];

[u1, u2] = SplitHaar;
u_hi = [u1, u2];
% u_hi = Daubechies8_1d;

nLevel = 2;  % level of DAS to plot output
%% Compute Filters

FB_real_FS = FS_fb{1};
FB_imag_FS = FS_fb{2};
FB_real = fb{1};
FB_imag = fb{2};


%% Initialization
for i = 1:2     % 1 for lowpass, 2 for highpass
    Real_DAS(i) = sqrt(2).*FB_real_FS(i);
    Imag_DAS(i) = sqrt(2).*FB_imag_FS(i);
end

%% Further Stages
for l = 2:nLevel
    Real_low = FB_real(1).upsamplefilter(2^(l-1));
    Imag_low = FB_imag(1).upsamplefilter(2^(l-1));
    Real_high = FB_real(2).upsamplefilter(2^(l-1));
    Imag_high = FB_imag(2).upsamplefilter(2^(l-1));

    Real_DAS(2) = convfilter(Real_DAS(1), Real_high);
    Imag_DAS(2) = convfilter(Imag_DAS(1), Imag_high);
    Real_DAS(1) = convfilter(Real_DAS(1), Real_low);
    Imag_DAS(1) = convfilter(Imag_DAS(1), Imag_low);
    for i = 1:2
        Real_DAS(i).filter = Real_DAS(i).filter*sqrt(2);
        Imag_DAS(i).filter = Imag_DAS(i).filter*sqrt(2);
    end
end


%% Complex
nband = 2;
DAS_Complex(nband) = filter1d;
I = sqrt(-1);
% figure;
for i = 1:nband
    DAS_Complex(i) = 1/sqrt(2).*(Real_DAS(i) + (I).*Imag_DAS(i));
end

%% Split
% tmp = DAS_Complex;
% DAS_Complex(1) = tmp(1).convfilter(u_low(1).upsamplefilter(2^nLevel));
% DAS_Complex(2) = tmp(1).convfilter(u_low(2).upsamplefilter(2^nLevel));
% DAS_Complex(3) = tmp(2).convfilter(u_hi(1).upsamplefilter(2^nLevel));
% DAS_Complex(4) = tmp(2).convfilter(u_hi(2).upsamplefilter(2^nLevel));



%% Plot in Frequency Domain
nband = length(DAS_Complex);
DAS_Freq(nband) = freqfilter1d;

for i = 1:nband
    DAS_Freq(i) = convert_ffilter(DAS_Complex(i), 1024);
end

% figure
plot_ffilter(DAS_Freq(2));


% legend('a_1^p','b_1^p', 'a_2^p', 'b_2^p','a_3^p', 'b_3^p','a_4^p', 'b_4^p');
% title('Dual Tree DAS, same L2 norm in different scale');

% figure;
% hif = u_hi.convert_ffilter(1024);
% plot_ffilter(hif)

% figure;
% hi(1) = u_hi(1).upsamplefilter(2^nLevel);
% hi(2) = u_hi(2).upsamplefilter(2^nLevel);
% 
% hif = hi.convert_ffilter(1024);
% plot_ffilter(hif)


% FB_real = Daubechies8_1d;
% FB_imag = FB_real;
% FB_imag(1).start_pt = FB_imag(1).start_pt + 1;
% FB_imag(2) = FB_imag(1).CQF;
% 
% I = sqrt(-1);
% DAS_Complex(1) = FB_real(1) + I.*FB_imag(1);
% DAS_Complex(2) = FB_real(2) + I.*FB_imag(2);
% 
% DAS_Freq = DAS_Complex.convert_ffilter(1024);
% plot_ffilter(DAS_Freq);






