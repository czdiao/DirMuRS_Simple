function [ obj2 ] = times( C, obj1 )
%TIMES Scalar Multiplication of the wavelet coefficients.
% obj2 = C.*obj1
%
%   Chenzhe
%   Jan, 2016


obj2 = obj1;
w = obj1.coeff;
nL = obj1.nlevel;
nB = obj1.nband;

for ilevel = 1:nL
    for dir1 = 1:2
        for part = 1:2
            for iband = 1:nB
                w{ilevel}{dir1}{part}{iband} = C*w{ilevel}{dir1}{part}{iband};
            end
        end
    end
end

%Last level output of the lowpass filter
for dir1 = 1:2
    for part = 1:2
        w{nL+1}{dir1}{part} = C*w{nL+1}{dir1}{part};
    end
end


end

