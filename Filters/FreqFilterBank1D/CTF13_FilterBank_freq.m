function [ fb1d ] = CTF13_FilterBank_freq( N )
%CTF13_FILTERBANK_FREQ Frequency filter bank of CTF13. Only 1D Filter Bank.
%Used to generate 2D CTF block filters.
%
%
%   Chenzhe
%   Mar, 2016
%

if nargin == 0
    N = 1024;
end


fb1d(13) = freqfilter1d;


c = [pi/16, pi/4, 7*pi/16, 7*pi/16+9*pi/64, 7*pi/16+9*pi/32, 7*pi/16+27*pi/64, pi];
e = [pi/16, pi/8-eps, pi/16, pi/16, pi/16, pi/16, pi/16];



for i = 1:6
    fb1d(2*i) = CTF_GenFilter_freq(c(i), c(i+1), e(i), e(i+1), N);
    fb1d(2*i).index = i;

    fb1d(2*i+1) = fb1d(2*i).conj_ffilter; % add the index automatically
    
end

fb1d(1) = CTF_GenFilter_freq(-c(1), c(1), e(1), e(1), N);
fb1d(1).index = 0;




end

