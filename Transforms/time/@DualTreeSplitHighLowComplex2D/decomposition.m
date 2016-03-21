function w = decomposition( obj, x )
%DECOMPOSITION Wavelet decomposition function
%
%   This is 2D DT-CWT with Split the highpass and lowpass
%
%   This version is called 'complex', can accept obj.u_hi or
%   obj.u_low to be complex filter banks.
%
%   Chenzhe
%   Jan, 2016


J = obj.nlevel;
u_hi = obj.u_hi;
u_low = obj.u_low;

w_orig = decomposition@DualTreeWavelet2D(obj, x);

w = cell(1, J+1);


for ilevel = 1:J
    w{ilevel} = cell(1, 2);
    
    % initialize memory
    for part = 1:2
        w{ilevel}{part} = cell(1,2);
        for dir = 1:2
            w{ilevel}{part}{dir} = cell(1,12);
        end
    end
    
    for dir = 1:2
        real_part = dir;
        imag_part = mod(dir, 2)+1;
        
        % w:    {LH}{HL}{HH}
        % 1. {LH}
        ud1 = u_low;
        ud2 = u_hi;
        if dir==1
            ud1 = conj(ud1);
        end
        [real_coeff, imag_coeff] = ...
            SplitPair(w_orig{ilevel}{real_part}{dir}{1}, w_orig{ilevel}{imag_part}{dir}{1}, ud1, ud2);
        for m = 1:4
            % band = 1,2,3,4
            w{ilevel}{real_part}{dir}{m} = real_coeff{m};
            w{ilevel}{imag_part}{dir}{m} = imag_coeff{m};
        end
        
        % 2. {HL}
        ud1 = u_hi;
        ud2 = u_low;
        if dir==1
            ud1 = conj(ud1);
        end
        [real_coeff, imag_coeff] = ...
            SplitPair(w_orig{ilevel}{real_part}{dir}{2}, w_orig{ilevel}{imag_part}{dir}{2}, ud1, ud2);
        for m = 1:4
            % band = 5,6,7,8
            w{ilevel}{real_part}{dir}{m+4} = real_coeff{m};
            w{ilevel}{imag_part}{dir}{m+4} = imag_coeff{m};
        end
        
        % 3. {HH}
        ud1 = u_hi;
        ud2 = u_hi;
        if dir==1
            ud1 = conj(ud1);
        end
        [real_coeff, imag_coeff] = ...
            SplitPair(w_orig{ilevel}{real_part}{dir}{3}, w_orig{ilevel}{imag_part}{dir}{3}, ud1, ud2);
        for m = 1:4
            % band = 9,10,11,12
            w{ilevel}{real_part}{dir}{m+8} = real_coeff{m};
            w{ilevel}{imag_part}{dir}{m+8} = imag_coeff{m};
        end
        
        
    end
end



w{J+1} = w_orig{J+1};

end


function [real_coeff, imag_coeff] = SplitPair(C_real, C_imag, u_d1, u_d2)
%%Split one band into 4 bands in 2d. Using tensor of u_d1 and u_d2.
% real_coeff{4}, imag_coeff{4}
% order:    (1,1), (1,2), (2,1), (2,2)

real_coeff = cell(1, 4);
imag_coeff = cell(1, 4);

[tmp_real, tmp_imag] = SplitPair1D(C_real, C_imag, u_d1(1), 1);
[real_coeff{1}, imag_coeff{1}] = SplitPair1D(tmp_real, tmp_imag, u_d2(1), 2);
[real_coeff{2}, imag_coeff{2}] = SplitPair1D(tmp_real, tmp_imag, u_d2(2), 2);

[tmp_real, tmp_imag] = SplitPair1D(C_real, C_imag, u_d1(2), 1);
[real_coeff{3}, imag_coeff{3}] = SplitPair1D(tmp_real, tmp_imag, u_d2(1), 2);
[real_coeff{4}, imag_coeff{4}] = SplitPair1D(tmp_real, tmp_imag, u_d2(2), 2);



end



function [real_coeff, imag_coeff] = SplitPair1D(C_real, C_imag, u, dim)
%%Split in 1D, with one complex u. Take one band into one band.
% This is just complex convolution.


I = sqrt(-1);
C = C_real + I*C_imag;

coeff = PostSplit(C, u, dim);

real_coeff = real(coeff);
imag_coeff = imag(coeff);


end


