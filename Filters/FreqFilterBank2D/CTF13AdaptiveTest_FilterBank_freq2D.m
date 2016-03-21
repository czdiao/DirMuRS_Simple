function [ fb2d ] = CTF13AdaptiveTest_FilterBank_freq2D( N )
%CTF13ADAPTIVETEST_FILTERBANK_FREQ2D Test Adaptive Filter Bank.
%
%   Manually designed for Barbara, use CTF13
%
%   Chenzhe
%   Mar, 2016
%

fb_orig = CTF13block_FilterBank_freq2D(N);

lowpass = fb_orig(1);
fb_orig(1) = [];

%% For Barbara
% nGroup = 16;
% Group = cell(1, nGroup);
% 
% Group{1} = [1,2,3,4];
% Group{2} = [6,7,8,10,11,12];
% Group{3} = [5,9];
% Group{4} = [13, 14];
% Group{5} = [15, 16,17, 18];
% Group{6} = [19, 25, 31];
% Group{7} = [20, 21, 26, 27, 32, 33];
% Group{8} = [22, 23, 24, 28, 29, 30, 34, 35, 36];
% Group{9} = [45, 52, 59, 66];
% Group{10} = [46, 47, 53, 54, 60, 61, 67, 68];
% Group{11} = [39, 40, 43, 44];
% Group{12} = [37, 38, 41, 42];
% Group{13} = [48, 49, 55, 56];
% Group{14} = [50, 51, 57, 58];
% Group{15} = [62, 63, 69, 70];
% Group{16} = [64, 65, 71, 72];

%% For Boat
nGroup = 18;
Group = cell(1, nGroup);

Group{1} = [1,2,3,4];
Group{2} = [5,6,7,8];
Group{3} = [9, 10, 16, 17, 18];
Group{4} = [11, 12];
Group{5} = [14, 15, 20, 21];
Group{6} = [26, 27, 32, 33];
Group{7} = [22, 23, 24, 28, 29, 30, 34, 35, 36];
Group{8} = [13, 45, 19, 52];
Group{9} = [25, 59, 31, 66];
Group{10} = [46, 47, 53, 54];
Group{11} = [60, 61, 67, 68];
Group{12} = [39, 40];
Group{13} = [37, 38, 43, 44];
Group{14} = [41, 42];
Group{15} = [48, 49, 55, 56];
Group{16} = [62, 63, 69, 70];
Group{17} = [50, 51, 57, 58];
Group{18} = [64, 65, 71, 72];





%%
fb2d(nGroup) = freqfilter2d;
for i = 1:nGroup
    len = length(Group{i});
    fb2d(i) = fb_orig(Group{i}(1));
    for j = 2:len
        no = Group{i}(j);
        fb2d(i) = fb2d(i).add(fb_orig(no));
    end
end

fb2d_conj = fb2d.conj_ffilter;
fb2d = [lowpass, fb2d, fb2d_conj];






end

