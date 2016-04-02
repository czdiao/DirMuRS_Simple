function obj2 = times(C, obj1)
%TIMES Scalar Multiplication of the wavelet coefficients.
%
% We need to use dot product to call this function
%
% obj2 = C.*obj1
%
%   Chenzhe
%   Mar, 2016

obj2 = obj1;
w = obj1.coeff;
nL = length(w)-1;

for ilevel = 1:nL
    nB = length(w{ilevel});
    for iband = 1:nB
        w{ilevel}{iband} = C*w{ilevel}{iband};
    end
end

%Last level output of the lowpass filter
w{nL+1} = C*w{nL+1};

obj2.coeff = w;



end

