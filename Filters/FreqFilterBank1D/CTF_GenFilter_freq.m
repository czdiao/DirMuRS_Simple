function Ffilter = CTF_GenFilter_freq( cL, cR, epsL, epsR, N )
%CTF_GENFILTER_FREQ Generate CTF type freqfilter1d filter.
%
%   We require cL, cR \in [-2pi, 2pi], and cL < cR
%
%   Chenzhe
%   Feb, 2016
%

Ffilter = freqfilter1d;
f = 0:1/N:(N-1)/N;
f = f*2*pi;

tmp = fchi(f, cL, cR, epsL, epsR);
if cL-epsL <=0
    tmp1 = fchi(f, cL+2*pi, cR+2*pi, epsL, epsR);
else
    tmp1 = fchi(f, cL-2*pi, cR-2*pi, epsL, epsR);
end

Ffilter.ffilter = tmp+tmp1;

end

