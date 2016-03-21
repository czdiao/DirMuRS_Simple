function fb2d = CTFAdaptiveTest_FilterBank_freq2D( N )
%CTFADAPTIVETEST_FILTERBANK_FREQ2D Test Adaptive Filter Bank.
%
%   Manually designed for Barbara, use CTF12
%
%   Chenzhe
%   Feb, 2016
%

fb_orig = CTFblock_FilterBank_freq2D(N);

lowpass = fb_orig(1);
fb_orig(1) = [];

nGroup = 15;
Group = cell(1, nGroup);

Group{1} = [1];
Group{2} = [2,3,4,98, 99, 100];
Group{3} = [5,6,7,8];
Group{4} = [10, 11];
Group{5} = [12, 13,14];
Group{6} = [16, 17, 22, 23, 28, 29];
Group{7} = [18, 19, 20, 24, 25, 26, 30, 31, 32];
Group{8} = [41, 9, 47, 15, 53, 21, 59, 27];
Group{9} = [42, 48, 54, 60];
Group{10} = [43, 44, 49, 50];
Group{11} = [55, 56, 61, 62];
Group{12} = [45, 46, 51, 52];
Group{13} = [57, 58, 63, 64];
Group{14} = [39, 40];
Group{15} = [33, 37, 38];

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

% undecimated hipass
% for i = 1:2*nGroup+1
%     fb2d(i).rate = 1;
% end


end

