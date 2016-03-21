function [ obj_new ] = plus( obj1, obj2 )
%PLUS Addition of the wavelet coefficients. Saved as Dual Tree 2D cell
%structure.
%
%   Chenzhe
%   Jan, 2016

w1 = obj1.coeff;
w2 = obj2.coeff;
w = w1;
nL = obj1.nlevel;
nB = obj1.nband;


for ilevel = 1:nL
    for dir1 = 1:2
        for real_imag = 1:2
            for iband = 1:nB
                w{ilevel}{dir1}{real_imag}{iband} =...
                    w{ilevel}{dir1}{real_imag}{iband} + w2{ilevel}{dir1}{real_imag}{iband};
            end
        end
    end
end

%Last level lowpass output
for dir1 = 1:2
    for real_imag = 1:2
        w{nL+1}{dir1}{real_imag} = w{nL+1}{dir1}{real_imag} + w2{nL+1}{dir1}{real_imag};
    end
end

obj_new = obj1;
obj_new.coeff = w;

end

