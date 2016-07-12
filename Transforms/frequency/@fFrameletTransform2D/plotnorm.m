function plotnorm( obj, val )
%PLOTNORM Show the bar plot of the norm, or some other val in the same data
%structure as obj.nor
%
%
%

if nargin == 1
    if isempty(obj.nor)
        error('Filter norm is not set! Call CalFilterNorm() first!');
    end
    nor = obj.nor;
else
    nor = val;
end

nL = obj.level_norm;
nB = length(obj.nor{1});

mat = zeros(nL, nB);

for ilevel = 1:nL
    for iband = 1:nB
        mat(ilevel, iband) = nor{ilevel}{iband};
    end
end

bar(mat)

end

