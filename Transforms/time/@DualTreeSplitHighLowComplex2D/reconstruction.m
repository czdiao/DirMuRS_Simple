function y = reconstruction( obj )
%RECONSTRUCTION Wavelet Reconstruction function
%
%   This function is the inverse of 2D DT-CWT with Split Hipass and lowpass
%
%   This version is called 'complex', we can accept obj.u_hi or
%   obj.u_low to be complex filter banks.
%
%   Chenzhe
%   Jan, 2016
%

w = obj.coeff;
J = obj.nlevel;
u_hi = obj.u_hi;
u_low = obj.u_low;


w_new = w;

for ilevel = 1:J
    for dir = 1:2
        r_ind = dir;
        i_ind = mod(dir, 2)+1;
        
        w_new{ilevel}{r_ind}{dir} = cell(1,3);
        w_new{ilevel}{i_ind}{dir} = cell(1,3);
        
        % 1. {LH}
        ud1 = u_low;    ud2 = u_hi;
        if dir==1
            ud1 = conj(ud1);
        end
        [real_coeff, imag_coeff] = CombinePair(w{ilevel}{r_ind}{dir}(1:4), w{ilevel}{i_ind}{dir}(1:4), ud1, ud2);
        w_new{ilevel}{r_ind}{dir}{1} = real_coeff;
        w_new{ilevel}{i_ind}{dir}{1} = imag_coeff;
        
        % 2. {HL}
        ud1 = u_hi;     ud2 = u_low;
        if dir ==1
            ud1 = conj(ud1);
        end
        [real_coeff, imag_coeff] = CombinePair(w{ilevel}{r_ind}{dir}(5:8), w{ilevel}{i_ind}{dir}(5:8), ud1, ud2);
        w_new{ilevel}{r_ind}{dir}{2} = real_coeff;
        w_new{ilevel}{i_ind}{dir}{2} = imag_coeff;
        
        % 3. {HH}
        ud1 = u_hi;     ud2 = u_hi;
        if dir ==1
            ud1 = conj(ud1);
        end
        [real_coeff, imag_coeff] = CombinePair(w{ilevel}{r_ind}{dir}(9:12), w{ilevel}{i_ind}{dir}(9:12), ud1, ud2);
        w_new{ilevel}{r_ind}{dir}{3} = real_coeff;
        w_new{ilevel}{i_ind}{dir}{3} = imag_coeff;
        
    end
end


obj.coeff = w_new;
y = reconstruction@DualTreeWavelet2D(obj);


end



function [real_coeff, imag_coeff] = CombinePair(C_real, C_imag, u_d1, u_d2)
%%C_real{4}, C_imag{4}, combined to be one pair

[real1, imag1] = CombinePair1D(C_real{1}, C_imag{1}, u_d2(1), C_real{2}, C_imag{2}, u_d2(2), 2);
[real2, imag2] = CombinePair1D(C_real{3}, C_imag{3}, u_d2(1), C_real{4}, C_imag{4}, u_d2(2), 2);

[real_coeff, imag_coeff] = CombinePair1D(real1, imag1, u_d1(1), real2, imag2, u_d1(2), 1);


end


function [real_coeff, imag_coeff] = CombinePair1D(C_real1, C_imag1, u1, C_real2, C_imag2, u2, dim)

I = sqrt(-1);

C1 = C_real1 + I*C_imag1;
C2 = C_real2 + I*C_imag2;

coeff = PostCombine(C1, u1, C2, u2, dim);

real_coeff = real(coeff);
imag_coeff = imag(coeff);


end



