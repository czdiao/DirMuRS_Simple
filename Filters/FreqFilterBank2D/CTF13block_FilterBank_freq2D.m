function [ fb2d ] = CTF13block_FilterBank_freq2D( N )
%CTF13BLOCK_FILTERBANK_FREQ2D Frequency filter bank of CTF blocks.
%
%   Use CTF13 here
%
%   Chenzhe
%   Mar, 2016

if nargin == 0
    N = 1024;
end

fb = CTF13_FilterBank_freq(N);


fb_low1 = add(fb(1), fb(2));
fb_low2 = add(fb(3), fb(4));
fb_low = add(fb_low1, fb_low2);
fb_low = add(fb_low, fb(5));
low2d = freqfilter2d(fb_low, fb_low);


%% Need to be implemented
fb = [fb(1), fb(2:2:end)];   % we only need filters on positive frequency side
fb_neg = fb.conj_ffilter;

fb2d1 = freqfilter2d(fb, fb(2:end));
fb2d2 = freqfilter2d(fb(2:end), fb_neg);

fb2d1(12+1:12+2) = [];
fb2d1(6+1:6+2) = [];
fb2d1(1:2) = [];

fb2d2(7+1:7+3) = [];
fb2d2(1:3) = [];

fb2d = [fb2d1, fb2d2];
fb2d = [fb2d, fb2d.conj_ffilter];

fb2d= [low2d, fb2d];





end

