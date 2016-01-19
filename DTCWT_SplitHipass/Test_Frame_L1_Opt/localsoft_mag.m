function [ W_new ] = localsoft_mag( W, Ssig, sigmaN )
%LOCALSOFT_MAG Summary of this function goes here
%   Detailed explanation goes here

W_new = W;
nL = W.nlevel;
nB = W.nband;
I = sqrt(-1);

for ilevel = 1:nL-1
    for dir = 1:2
        for iband = 1:nB
            coeff_real = W.coeff{ilevel}{1}{dir}{iband};
            coeff_imag = W.coeff{ilevel}{2}{dir}{iband};
            Coeff = coeff_real + I*coeff_imag;
            T = sigmaN^2./Ssig{ilevel}{dir}{iband};
            
%             Coeff = local_soft_complex(Coeff, T);
            Coeff = (abs(Coeff) >= T).*(Coeff-T.*Coeff./abs(Coeff));
            W_new.coeff{ilevel}{1}{dir}{iband} = real(Coeff);
            W_new.coeff{ilevel}{2}{dir}{iband} = imag(Coeff);
            
        end
    end
end



end



function y = local_soft_complex(x, T)

R = abs(x)-T;
R = R.*(R>0);

y = x.* R./(R+T);


end
