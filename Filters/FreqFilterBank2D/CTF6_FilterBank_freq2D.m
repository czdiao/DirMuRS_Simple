function [ fb2d ] = CTF6_FilterBank_freq2D( N )
%CTF6_FILTERBANK_FREQ2D 2D Frequency filter bank of CTF6.
%
%   Chenzhe
%   Feb, 2016

if nargin == 0
    N = 1024;
end

fb = CTF6_FilterBank_freq(N);

fb2d = freqfilter2d(fb, fb);
fb2d(8) = [];
fb2d(7) = [];
fb2d(2) = [];

f1 = fb(1).ffilter;
f2 = fb(2).ffilter;
af = sqrt(f1.^2 + f2.^2);
a = freqfilter1d;
a.ffilter = af;
fb2d(1) = freqfilter2d(a,a);


end

