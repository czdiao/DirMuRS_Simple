function plotnorm( obj )
%PLOTNORM Show the bar plot of the norm

if isempty(obj.nor)
    error('Filter norm is not set! Call CalFilterNorm() first!');
end

nL = obj.level_norm;
nB = length(obj.nor{1});

mat = zeros(nL, nB);
nor = obj.nor;

for ilevel = 1:nL
    for iband = 1:nB
        mat(ilevel, iband) = nor{ilevel}{iband};
    end
end

bar(mat)

end

