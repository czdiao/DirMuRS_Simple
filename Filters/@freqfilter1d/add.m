function obj_new = add(obj1, obj2)
%ADD Add 2 frequency filters in square average way. This is used to combine
%filters. This works for CTF type filters.
%
%   Chenzhe
%   Feb, 2016
%

M1 = length(obj1.ffilter);
M2 = length(obj2.ffilter);

M = min(M1, M2);
Mbig = max(M1, M2);
if mod(Mbig, M)~=0
    error('Sampling rate does not match!');
end

obj1 = obj1.filterdownsample(M1/M);
obj2 = obj2.filterdownsample(M2/M);

obj_new = obj1;
f1 = obj1.ffilter;
f2 = obj2.ffilter;
f_new = sqrt(f1.^2 + f2.^2);
obj_new.ffilter = f_new;






end

