function [ w ] = Framelet1d_new( data, J, FilterBank )
%FRAMELET1D_NEW Summary of this function goes here
%   Detailed explanation goes here
%
%   Author: Chenzhe Diao

NFilter = length(FilterBank);

w = cell(1, J+1);

for ilevel = 1:J
    w{ilevel} = cell(1, NFilter-1);
    for iband = 2:NFilter
        w{ilevel}{iband-1} = analysis(FilterBank(iband), data, 2);
    end
    data = analysis(FilterBank(1), data, 2);
end

w{J+1} = data;


end

