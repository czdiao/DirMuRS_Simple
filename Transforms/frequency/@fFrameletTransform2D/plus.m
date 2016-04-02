function obj_new = plus(obj1, obj2)
%PLUS Addition of the wavelet coefficients.
%
%
%   Chenzhe
%   Mar, 2016

w = obj1.coeff;
w2 = obj2.coeff;

nLevel = length(w);

for j = 1:nLevel-1
    nband = length(w{j});
    for iband = 1:nband
        w{j}{iband} = w{j}{iband} + w2{j}{iband};
    end
end

w{nLevel} = w{nLevel} + w2{nLevel};

obj_new = obj1;
obj_new.coeff = w;


end

