function fb1d = CTF12_FilterBank_freq( N )
%CTF12_FILTERBANK_FREQ Frequency filter bank of CTF12. Only 1D Filter Bank.
%Used to generate 2D CTF block filters.
%
%   Chenzhe
%   Feb, 2016
%

if nargin == 0
    N = 1024;
end

% Choice 1. 
% Should not use this filter bank. The lowpass is not supported as [-pi/2, pi/2].
% So we would get 0 highpass filter in the second level. We fix this by Choice 2.
%
% fb1d(12) = freqfilter1d;
% 
% c = linspace(0,pi,7);
% dx = pi/6;
% e = dx/3;
% 
% for i = 0:5
%     fb1d(2*i+1) = CTF_GenFilter_freq(c(i+1), c(i+2), e, e, N);
%     fb1d(2*i+2) = fb1d(2*i+1).conj_ffilter;
% end

% Choice 2
fb1d(12) = freqfilter1d;

% c = [0, 7*pi/32, 7*pi/16, 7*pi/16+9*pi/64, 7*pi/16+9*pi/32, 7*pi/16+27*pi/64, pi];
% e = [7*pi/96, 7*pi/96, pi/16, pi/16, pi/16, pi/16, pi/16];

c = [0, 7*pi/32, 7*pi/16, 7*pi/16+9*pi/64, 7*pi/16+9*pi/32, 7*pi/16+27*pi/64, pi];
e = [7*pi/96, 2*7*pi/96, pi/16, pi/16, pi/16, pi/16, pi/16];

% c = [0, 7*pi/32, 7*pi/16, 7*pi/16+9*pi/64, 7*pi/16+9*pi/32, 7*pi/16+27*pi/64, pi];
% e = [7*pi/64, 7*pi/64, pi/16, pi/16, pi/16, pi/16, pi/16];


for i = 0:5
    fb1d(2*i+1) = CTF_GenFilter_freq(c(i+1), c(i+2), e(i+1), e(i+2), N);
    fb1d(2*i+1).index = i+0.5;

    fb1d(2*i+2) = fb1d(2*i+1).conj_ffilter; % add the index automatically
    
end


end

