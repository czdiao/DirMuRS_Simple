function [ hi ] = CQF( lo )
%CQF Generate the 1D highpass filter from lowpass filter in CQF pairs
% CQF:  b_n = (-1)^(n+1) a_{1-n}


len = length(lo.filter);
hi.filter = lo.filter(end:-1:1);
hi.start_pt = 1 - (lo.start_pt + len - 1);

flip = ones(1,len);
if mod(hi.start_pt, 2)==1
    s = 2;
else
    s = 1;
end

for i = s:2:len
    flip(i) = -1;
end

hi.filter = hi.filter.*flip;



end

