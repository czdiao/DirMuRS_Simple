function variance = cal_variance(w)
%Calculate the local variance in a window of all the wavelet coefficients.
%Input:
%   w is the wavelet coefficients, including all levels.
%Output:
%   variance is a col vector. Containing all the local variances from all
%   levels and all bands.
%
%   Note:   This function is for statistical use.
%
%   Chenzhe Diao
%   Aug, 2015.

nlevel = length(w)-1;

windowsize = 7;
windowfilt = ones(1,windowsize)/windowsize;

variance = [];

for level = 1:nlevel
    nband = length(w{level});
    for iband = 1:nband
        L = length(w{level}{iband});
        buffer_size = L/2;
        w{level}{iband} = symext(w{level}{iband},buffer_size);
        Wsig = conv2(windowfilt,windowfilt,(abs(w{level}{iband})).^2,'same');
        ind = buffer_size+1 : buffer_size+L;
        Wsig = Wsig(ind,ind);
        Wsig = sqrt(Wsig);
        variance = [variance; Wsig(:)];

    end
end









end