function HaarFilter = Haar1d
%Haar1d Generate 1d Haar filter bank


low = filter1d([0.5, 0.5], 0, 'low');

% CQF:  b_n = (-1)^(n+1) a_{1-n}
hi = CQF(low);

HaarFilter = [low, hi];


end

