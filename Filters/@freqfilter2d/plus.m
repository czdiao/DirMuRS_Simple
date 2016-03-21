function obj_new = plus(obj1, obj2)
%PLUS Sum of 2 freqfilter2d objects.
%
%
%   Chenzhe
%   Feb, 2016
%

[M1, N1] = size(obj1.ffilter);
[M2, N2] = size(obj2.ffilter);

M = min(M1, M2);
N = min(N1, N2);
Mbig = max(M1, M2);
Nbig = max(N1, N2);
if mod(Mbig, M)~=0 || mod(Nbig, N)~=0
    error('Sampling rate does not match!');
end

obj1 = obj1.filterdownsample(M1/M, N1/N);
obj2 = obj2.filterdownsample(M2/M, N2/N);

obj_new = obj1;
obj_new.ffilter = obj1.ffilter + obj2.ffilter;





end

