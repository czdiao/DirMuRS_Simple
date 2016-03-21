function w = decomposition(obj, x)
%DECOMPOSITION TPCTF2D decomposition.
%
%   The transform is implemented using 2d filter freqfilter2d.
%
%   Chenzhe
%   Feb, 2016
%

fdata = fft2(x);    % Change the data into frequency domain
nL = obj.nlevel;
FB = obj.FilterBank2D;
nFilters = length(FB);

w = cell(1, nL+1);

for ilevel = 1:nL
    w{ilevel} = cell(1, nFilters-1);
    for iband = 2:nFilters
%         w{ilevel}{iband-1} = fanalysis(FB(iband), fdata, 2, 2);
        w{ilevel}{iband-1} = fanalysis(FB(iband), fdata);
    end
%     fdata = fanalysis(FB(1), fdata, 2, 2);
    fdata = fanalysis(FB(1), fdata);

end

w{nL+1} = fdata;

w = obj.wifft2(w);  % Change the coeff back to time domain



end

