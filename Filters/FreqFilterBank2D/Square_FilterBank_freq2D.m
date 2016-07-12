function [ fb2d ] = Square_FilterBank_freq2D( C, Lv, N )
%SQUARE_FILTERBANK_FREQ2D Frequency filter bank in angular partition.
%
%   Called by GenSquare_FB_freq2D_average()
%
%Input:
%   C:
%       Array for partition point in (0, pi).
%   Lv:
%       Number of Scales. We construct the higher level filters directly by
%       adding partitions inside the inner bump.
%   N:  (Optional)
%       Number of discrete frequency in cartesian coords.
%
%   Chenzhe
%   Jun, 2016
%

if nargin == 2
    N = 1024;
end

endpoint = pi;
fb2d = Square_FilterBank_freq2D_1level(C, N, endpoint);

r = C(1)/pi;    % similar to decimation rate, shrinkage rate in freq domain of next level
for ilevel = 2:Lv
    lowpass = fb2d(1);
    endpoint = C(1);
    C = C*r;
    fb2d_new = Square_FilterBank_freq2D_1level(C, N, endpoint);
    
    len = length(fb2d_new);
    for j = 1:len
        fb2d_new(j).ffilter = fb2d_new(j).ffilter.*lowpass.ffilter;
    end
    
    fb2d(1) = fb2d_new(1);
    fb2d = [fb2d, fb2d_new(2:end)];

end


end

function fb2d = Square_FilterBank_freq2D_1level(C, N, endpoint)
%Require C to be an increasing sequence in (0, endpoint)
% The sum of square of the generated fb2d will be 1 inside the frequency
% square [-endpoint, endpoint]^2
%


L = length(C);

% set up for 1d hipass
fb1d(2*L) = freqfilter1d;   % partition on positive freq
fb1d_neg = fb1d;            % partition on negative freq

epsR = (endpoint-C(end))/3.1;
epsL = epsR;
cR = endpoint;
cL = C(L) + epsR*1.05;

fb1d(2*L) = CTF_GenFilter_freq(cL, cR, epsL, epsR, N);
fb1d_neg(2*L) = CTF_GenFilter_freq(-cR, -cL, epsR, epsL, N);
if endpoint~=pi
    negback = CTF_GenFilter_freq(cL-2*endpoint, cR-2*endpoint, epsL, epsR, N);
    fb1d(2*L) = add(fb1d(2*L), negback);
    
    posback = CTF_GenFilter_freq(-cR+2*endpoint, -cL+2*endpoint, epsR, epsL, N);
    fb1d_neg(2*L) = add(fb1d_neg(2*L), posback);
end

for i = (L-1):(-1):1
    epsR = epsL;
    cR = cL;
    epsL = (C(i+1) - C(i))/4.1;
    cL = C(i+1) - epsL*1.025;
    fb1d(2*i+1) = CTF_GenFilter_freq(cL, cR, epsL, epsR, N);
    fb1d_neg(2*i+1) = CTF_GenFilter_freq(-cR, -cL, epsR, epsL, N);

    
    epsR = epsL;
    cR = cL;
    cL = C(i) + epsL*1.025;
    fb1d(2*i) = CTF_GenFilter_freq(cL, cR, epsL, epsR, N);
    fb1d_neg(2*i) = CTF_GenFilter_freq(-cR, -cL, epsR, epsL, N);
end

epsR = epsL;
cR = cL;
cL = C(1) - epsL*1.025;
fb1d(1) = CTF_GenFilter_freq(cL, cR, epsL, epsR, N);
fb1d_neg(1) = CTF_GenFilter_freq(-cR, -cL, epsR, epsL, N);

% inner split lowpass as highpass
epsR = epsL;
cR = cL;
epsL = (C(1) - epsR*2.05)/1.1;
hiInner = CTF_GenFilter_freq(0, cR, epsL, epsR, N);
hiInner.label = 'low';
hiInner_neg = CTF_GenFilter_freq(-cR, 0, epsR, epsL, N);
hiInner_neg.label = 'low';

% make label for all potential 1d hipass
for i = 1:2*L
    fb1d(i).label = 'high';
    fb1d_neg(i).label = 'high';
end
fb1d = [hiInner, fb1d];
fb1d_neg = [hiInner_neg, fb1d_neg];

% generate 1d for lowpass
lowpass1d = CTF_GenFilter_freq(-cR, cR, epsR, epsR, N);
% generate 2d for lowpass
lowpass2d = freqfilter2d(lowpass1d, lowpass1d);


% generate 2d for highpass
fb1d = [fb1d, fb1d_neg];

len = length(fb1d);
fb2d(len^2-4) = freqfilter2d;
count = 1;
for i = 1:len
    for j = 1:len
        if (strcmp(fb1d(i).label, 'low')) && (strcmp(fb1d(j).label, 'low'))
            continue;
        else
            fb2d(count) = freqfilter2d(fb1d(i), fb1d(j));
            count = count+1;
        end
    end
end

fb2d = [lowpass2d, fb2d];



end

