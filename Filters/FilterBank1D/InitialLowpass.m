function [ az, uz ] = InitialLowpass( t1, t2 )
%INITIALLOWPASS Construction of Lowpass filter of the initial filter bank.
% In dual-tree structure, we can design some special lowpass filters for
% the first stage, to achieve better directionality.
%
%   Chenzhe
%   Nov, 2015

% choose m=2, n=2

pp = [t2, t1+t2, 1, 1]; % take away the (1-x) factor, for less roundoff error.
az = FejerRieszReal(pp);
az = az.convfilter(filter1d([0.5, 0.5], 0));    % add back the (1-x) term
L = length(az.filter);
az.start_pt = -floor(L/2);

% take away the x^2 term
Q = [t2, -2*t2 - t1, 1];
% Since Q(1) = 1, shift by pi, use y = 1-x = cos^2(xi/2)
uz = FejerRieszReal(Q);
uz = uz.freqshift(pi);
uz = Real(uz);
uz = uz.convfilter(filter1d([-1/4, 1/2, -1/4], -1));    % add back the x^2 term.
uz = sqrt(2).* uz;

L = length(uz.filter);
uz.start_pt = -floor(L/2);


end

