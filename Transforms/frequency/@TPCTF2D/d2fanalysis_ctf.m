function [L, H] = d2fanalysis_ctf( fdata, rate, Ffb_c, Ffb_r )
%D2FANALYSIS_CTF Analysis operation in 2D, with col and row Filter Banks
%given. Works for TP-CTF transforms.
%
%   Bugs, doesn't work now
%   
%   Chenzhe
%   Feb, 2016
%

if nargin == 3
    Ffb_r = Ffb_c;
end

len_c = length(Ffb_c);
len_r = length(Ffb_r);

% Add the conjugate filters of highpass of Ffb_r
Ffb_r(2*len_r-1) = freqfilter1d;    % initialize the memory
for i = 1:(len_r-1)
    Ffb_r(len_r+i) = conj_ffilter(Ffb_r(i+1));
end

num_hi = len_c*(2*len_r-1)-len_r;
H = cell(1, num_hi);

tmp = fanalysis(Ffb_c(1), fdata, rate, 1);
L = fanalysis(Ffb_r(1), tmp, rate, 2);  % LL output

count = 1;
for i = 2:len_r     % LH(i) output
    H{count} = fanalysis(Ffb_r(i), tmp, rate, 2);
    count = count+1;
end

% H(j)H(i) and H(j)L output
len_r = 2*len_r-1;
for j = 2:len_c
    tmp = fanalysis(Ffb_c(j), fdata, rate, 1);
    for i = 1:len_r
        H{count} = fanalysis(Ffb_r(i), tmp, rate, 2);
        count = count+1;
    end
end




end

