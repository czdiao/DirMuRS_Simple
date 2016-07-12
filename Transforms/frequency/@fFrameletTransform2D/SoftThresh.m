function [ W ] = SoftThresh( obj, T )
%SOFTTHRESH Bandwise soft thresholding, T{}{} is the thresh value for each
%band.
%
%Input:
%   T:
%       Should be of the same data structure with the obj.coeff
%       T{ilevel}{iband} could be a matrix of the same size as the coeff in
%       each band, or a single number in each band is OK.
%Output:
%   W:
%       Output wavelet coeff
%
%   Note:
%       This thresholding only applies to highpass bands. And leave the
%       lowpass output unchanged.
%
%   Chenzhe
%   April, 2016
%


nL = obj.nlevel;
W = obj.coeff;

for iL = 1:nL
    nB = length(W{iL});
    for iB = 1:nB
        W{iL}{iB} = soft(W{iL}{iB},T{iL}{iB});
        
    end
end




end

