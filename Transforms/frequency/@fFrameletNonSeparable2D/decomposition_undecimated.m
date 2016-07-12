function  w  = decomposition_undecimated( obj, x )
%DECOMPOSITION_UNDECIMATED Undecimated TPCTF2D decomposition.
%
%   The transform is implemented using 2d filter freqfilter2d.
%   Undecimated version.
%
%
%   Chenzhe
%   Feb, 2016
%

fdata = fft2(x);    % Change the data into frequency domain
nL = obj.nlevel;
FB = obj.FilterBank2D;
nFilters = length(FB);

rate = FB(1).rate;
for i = 1:nFilters
    FB(i).rate = 1;     % for undecimated, use up/downsampling rate 1
end


w = cell(1, nL+1);

for ilevel = 1:nL
    w{ilevel} = cell(1, nFilters-1);
    for iband = 2:nFilters
        w{ilevel}{iband-1} = fanalysis(FB(iband), fdata);
    end
    
    fdata = fanalysis(FB(1), fdata);
    FB = FB.timeupsample(rate, rate);

end

w{nL+1} = fdata;

w = obj.wifft2(w);  % Change the coeff back to time domain


end

