function [ v ] = convert2array( obj )
%CONVERT2ARRAY Convert all the wavelet coefficients to an array of data.
% Use for data analysis
%
%   Chenzhe
%   Jan, 2016

nL = obj.nlevel;
nB = obj.nband;
w = obj.coeff;
v = [];


for ilevel = 1:nL
    for dir1 = 1:2
        for part = 1:2
            for iband = 1:nB
                v = [v; w{ilevel}{dir1}{part}{iband}(:)];
            end
        end
    end
end

%Last level output of the lowpass filter
for dir1 = 1:2
    for part = 1:2
        v = [v; w{nL+1}{dir1}{part}(:)];
    end
end





end

