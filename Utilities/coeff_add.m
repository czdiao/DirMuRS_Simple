function w = coeff_add(w1, w2)

nlevel = length(w1)-1;
if length(w2)~=(nlevel+1)
    error('Coeff length does not match!\n');
end

w = w1;
for i = 1:nlevel
    nband = length(w1{i});
    if length(w2{i})~=nband
        error('Number of bands does not match!\n');
    end
    for iband = 1:nband
        w{i}{iband} = w1{i}{iband}+w2{i}{iband};
    end
end

w{nlevel+1} = w1{nlevel+1}+w2{nlevel+1};



end