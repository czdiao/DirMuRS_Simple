function [ fb1d ] = CTF3_FilterBank_freq(N)
%CTF3_FILTERBANK_FREQ Frequency filter bank of CTF3.
%
%   Chenzhe
%   Feb, 2016
%

if nargin == 0
    N = 1024;
end

flow = freqfilter1d;
f = 0:1/N:(N-1)/N;
f = f*2*pi;
tmp = fchi(f, -33/32, 33/32, 69/128, 69/128);
tmp2 = fchi(f, 2*pi-33/32, 2*pi+33/32, 69/128, 69/128);
flow.ffilter = tmp + tmp2;

fhigh = freqfilter1d;
fhigh.ffilter = fchi(f, 33/32, pi, 69/128, 51/512);

fb1d = [flow, fhigh];

fn = fhigh.conj_ffilter;
fb1d = [fb1d, fn];


end

