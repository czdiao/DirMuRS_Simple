function [ fb1d ] = CTF6_FilterBank_freq(N)
%CTF6_FILTERBANK_FREQ Frequency filter bank of CTF6.
%
%   1D filter bank of CTF6. We don't include the combined lowpass here.
%   The combined lowpass could be got by: 
%		flow = add(fb1d(1), fb1d(2))
%   See CTF6_FilterBank_freq2D() for 2D construction.
%
%   Chenzhe
%   Feb, 2016
%

f = 0:1/N:(N-1)/N;
f = f*2*pi;

f1 = freqfilter1d;
tmp = fchi(f, 0, 119/128, 35/128, 81/128);
tmp2 = fchi(f, 2*pi, 2*pi+119/128, 35/128, 81/128);
f1.ffilter = tmp + tmp2;

f2 = freqfilter1d;
f2.ffilter = fchi(f, 119/128, (pi+119/128)/2, 81/128, 115/256);

f3 = freqfilter1d;
f3.ffilter = fchi(f, (pi+119/128)/2, pi, 115/256, 115/256);

f11 = f1.conj_ffilter;
f21 = f2.conj_ffilter;
f31 = f3.conj_ffilter;


fb1d = [f1, f11, f2, f21, f3, f31];





end

