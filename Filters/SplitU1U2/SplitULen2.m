function [ u1, u2 ] = SplitULen2( c0, xi0 )
%SPLITULEN2 Generate U1 and U2 filter pair of length <= 2
%   U1 and U2 only satisfies the partition of unity in the freq domain.
%   U1 and U2 could be complex filters.
%
%   c0 \in [0, 1] would cover all cases
%   xi0 \in T
%
%   Chenzhe
%   Nov, 2015

if c0 >=0
    c1 = 1-c0;
else
    c1 = -1-c0;
end

e1 = sqrt(c0*c1);

u1 = filter1d([c1, c0], -1);
u2 = filter1d([e1, -e1], -1);

u1 = u1.freqshift(xi0);
u2 = u2.freqshift(xi0);

end

