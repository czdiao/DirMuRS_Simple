function [ u1, u2 ] = SplitULen3( e0, xi0 )
%SPLITULEN3 Generate U1 and U2 filter pair of length <= 3
%   With U2 has vanishing moment 2.
%
%   U1 and U2 only satisfies the partition of unity in the freq domain.
%   U1 and U2 could be complex filters.
%
%   abs(e0)<=1/4
%
%   Chenzhe
%   Nov, 2015

z1 = ((2*e0 + 1) + sqrt(4*e0 + 1))/(2*e0);
z2 = ((2*e0 - 1) + sqrt(-4*e0 + 1))/(2*e0);

u2 = filter1d([1, -1], -1);
u2 = u2.convfilter(u2);
u2 = e0 .* u2;
u2.start_pt = -1;

f1 = filter1d([1, -z1],-1);
f2 = filter1d([1, -z2], -1);
u1 = f1.convfilter(f2);
C = sqrt(-e0^2/(z1*z2));
u1 = C.* u1;
u1.start_pt = -1;

u1 = u1.freqshift(xi0);
u2 = u2.freqshift(xi0);

end

