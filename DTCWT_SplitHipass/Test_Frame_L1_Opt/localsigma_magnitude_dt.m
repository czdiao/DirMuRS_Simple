function [ Ssig ] = localsigma_magnitude_dt( W )
%LOCALSIGMA_MAGNITUDE_DT Summary of this function goes here
%   Detailed explanation goes here

nL = W.nlevel;
nB = W.nband;
I = sqrt(-1);


Ssig = cell(1, nL);

for ilevel = 1:nL
    Ssig{ilevel} = cell(1,2);
    for dir = 1:2
        Ssig{ilevel}{dir} = cell(1, nB);
        for iband = 1:nB
            coeff_real = W.coeff{ilevel}{1}{dir}{iband};
            coeff_imag = W.coeff{ilevel}{2}{dir}{iband};
            Magnitude = abs(coeff_real + I*coeff_imag);
            
            Ssig{ilevel}{dir}{iband} = local_variance(Magnitude);
        end
    end
end






end

