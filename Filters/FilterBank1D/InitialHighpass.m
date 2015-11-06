function [ b1, b2 ] = InitialHighpass( uz, c1, d1 )
%INITIALHIGHPASS Construction of the Highpass filter of the initial filter
%bank in the DT-CWT.
%   Chenzhe Diao
%   Nov. 2015

tmp = c1^2 + d1^2;
c2 = (tmp - c1)/2;


%% Case 1 for d2
d2 = (-d1 + sqrt(tmp*(1-tmp)))/2;
c0 = 1 - 2*c1 -2*c2;
d0 = -2*d1 - 2*d2;

I = sqrt(-1);
vec = [c2+I*d2, c1+I*d1, c0+I*d0, c1+I*d1, c2+I*d2];
wz = filter1d(vec,-2);

wz = wz.convfilter(filter1d([0.5, 0.5], -1));

v = wz.freqshift(pi/2);

bp1 = v.convfilter(uz);

%% Case 2 for d2
d2 = (-d1 - sqrt(tmp*(1-tmp)))/2;
c0 = 1 - 2*c1 -2*c2;
d0 = -2*d1 - 2*d2;

I = sqrt(-1);
vec = [c2+I*d2, c1+I*d1, c0+I*d0, c1+I*d1, c2+I*d2];
wz = filter1d(vec,-2);

wz = wz.convfilter(filter1d([0.5, 0.5], -1));

v = wz.freqshift(pi/2);

bp2 = v.convfilter(uz);

%% Choose best bp for freq seperation
bp1sq = bp1.convfilter(bp1.conjflip);
Int1 = real(IntNegReal(bp1sq));
bp2sq = bp2.convfilter(bp2.conjflip);
Int2 = real(IntNegReal(bp2sq));

if Int1<=Int2
    bp = bp1;
else
    bp = bp2;
end


b1 = bp.Real;
b2 = bp.Imag;

end

