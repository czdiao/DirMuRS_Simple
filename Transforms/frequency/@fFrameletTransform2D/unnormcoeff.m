function W = unnormcoeff(obj)
%UNNORMCOEFF Unnormalized the coefficeint of 2D framelet transform.
% 	Inverse of normcoeff(obj)
%
%   Chenzhe
%   Feb, 2016
%

if isempty(obj.nor)
    error('The filter norm has not been calculated, call CalFilterNorm()!');
elseif isempty(obj.coeff)
    error('The coefficients has not been computed, call decomposition()!');
end

nL = obj.nlevel;
nor = obj.nor;
W = obj.coeff;

for iL = 1:nL
    nband = length(W{iL});
    for iband = 1:nband
        W{iL}{iband} = W{iL}{iband}*nor{iL}{iband};
    end
end





end

