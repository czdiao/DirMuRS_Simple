function [ x ] = d2fsynthesis_ctf( w, rate, Ffb_c, Ffb_r )
%D2FSYNTHESIS_CTF Synthesis operation in 2D, with col and row Filter Banks
%given. Works for TP-CTF transforms.
%
%   Both w and x are in frequency domain.
%
%   Bugs, doesn't work now.
%
%   Chenzhe
%   Feb, 2016
%

if nargin == 3
    Ffb_r = Ffb_c;
end

len_r = length(Ffb_r);
len_c = length(Ffb_c);


tmp = cell(1, len_c);

% Synthesis LH(i) for all i
w{1} = w{1}/2;
tmp{1} = fsynthesis(Ffb_r, w(1:len_r), rate, 2);


% For HH and HL part, we need to add the conjugate filters of Ffb_r highpass
Ffb_r(2*len_r-1) = freqfilter1d;    % initialize the memory
for i = 1:(len_r-1)
    Ffb_r(len_r+i) = conj_ffilter(Ffb_r(i+1));
end

len_r_ext = 2*len_r-1;
ind1 = 1:len_r_ext;
for i = 2:len_c
    ind = ind1 + len_r + len_r_ext*(i-2);
    tmp{i} = fsynthesis(Ffb_r, w(ind), rate, 2);
end


x = fsynthesis(Ffb_c, tmp, rate, 1);

x = x + fconj(x);


end

