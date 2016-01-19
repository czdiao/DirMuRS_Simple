function [ E ] = energyL1( y, c, W, sigmaN, W_true )
%ENERGYL1 Summary of this function goes here
%   Detailed explanation goes here


E = 0.5 * sum(sum((y-c).^2));

nL = W_true.nlevel;
nB = W_true.nband;

for ilevel = 1:nL
    for d1 = 1:2
        for d2 = 1:2
            for iband = 1:nB
                Ssig = local_variance(W_true.coeff{ilevel}{d1}{d2}{iband});
                W.coeff{ilevel}{d1}{d2}{iband} = W.coeff{ilevel}{d1}{d2}{iband}./Ssig;
            end
        end
    end
end

E = E + sigmaN*2 * norm(W, 1);


end

