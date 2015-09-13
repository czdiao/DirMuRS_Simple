function [ fb2d ] = Daubechies8_2d
%Daubechies8Filter2d 
%   2D Daubechies8 Filter Bank

fb1d = Daubechies8_1d;

fb2d = FilterBankTensor(fb1d, fb1d);

end

