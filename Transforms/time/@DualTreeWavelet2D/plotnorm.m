function plotnorm( obj )
%PLOTNORM Show the bar plot of the norm

if isempty(obj.nor)
    error('Filter norm is not set! Call CalFilterNorm() first!');
end

nL = obj.nlevel;
nB = obj.nband;

mat = zeros(nL, nB*4);
nor = obj.nor;

for ilevel = 1:nL
    count = 1;
    for d2 = 1:2
        for d1 = 1:2
            for iband = 1:nB
                mat(ilevel, count) = nor{ilevel}{d1}{d2}{iband};
                count = count+1;
            end
        end
    end
end

bar(mat)

end

