function highpass = CQF(lowpass)
%CQF alternating shift for constructing highpass
% Generate the 1D highpass filter from lowpass filter in CQF pairs
% $b_n = (-1)^(n+1) a_{1-n}$
len = length(lowpass.filter);
highpass = filter1d;
highpass.filter = conj(lowpass.filter(end:-1:1));
highpass.start_pt = 1 - (lowpass.start_pt + len - 1);

flip = ones(1,len);
if mod(highpass.start_pt, 2)==1
    s = 2;
else
    s = 1;
end

for i = s:2:len
    flip(i) = -1;
end

highpass.filter = highpass.filter.*flip;
highpass.label = 'high';
end