function f1d_flip = conjflip(f1d)
%Conjugate flip of the filter
% a_new(n) = conj(a(-n))
len = length(f1d.filter);
flip_start_pt = (f1d.start_pt + len - 1) * (-1);

f1d_flip = filter1d;
f1d_flip.filter = conj(f1d.filter(end:-1:1));
f1d_flip.start_pt = flip_start_pt;
f1d_flip.label = f1d.label;

end