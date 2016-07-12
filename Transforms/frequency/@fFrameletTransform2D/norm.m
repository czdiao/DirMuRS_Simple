function [ n ] = norm( obj, p )
%NORM Lp norm of the wavelet coefficients. For fFrameletTransform2D class.
%
%   0 <= p < inf
%   Default is l2 norm.
%
%   Chenzhe
%   April, 2016
%

if nargin == 1
    p = 2;
end
w = obj.coeff;
nL = obj.nlevel;

n = 0;
if p==0 % zero norm
    for iL = 1:nL
        nB = length(w{iL});
        for iB = 1:nB
            tmp = abs(w{iL}{iB})>eps;
            n = n + nnz(tmp);
        end
    end
    tmp = abs(w{nL+1})>eps;
    n = n + nnz(tmp);
elseif (p>0) && (p~=inf)  % p norm
    for iL = 1:nL
        nB = length(w{iL});
        for iB = 1:nB
            n = n + sum(sum(abs(w{iL}{iB}).^p));
        end
    end
    n = n + sum(sum(abs(w{nL+1}).^p));
    n = n^(1/p);
elseif p == inf  % inf norm
    for iL = 1:nL
        nB = length(w{iL});
        for iB = 1:nB
            tmp = max(max(abs(w{iL}{iB})));
            n = max(n ,tmp);
        end
    end
    tmp = max(max(abs(w{nL+1})));
    n = max(n ,tmp);
else
    error('Wrong input!');
end


end

