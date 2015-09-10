function [ betahat ] = Calbeta( X,M,r,beta )
%Calbeta Calculate shape parameter beta for GGD
%   betahat = Calbeta(X,M,r,beta)
%   X is coefficients vector, M is the number of coefficients in X.
%   r and beta are lookup tables.
mux = sum(X)/M;
sigmax2 = sum((X-mux).^2)/M;
E2 = (sum(abs(X-mux))/M)^2;
rhat = sigmax2/E2;

dif = abs(r-rhat);
i = find(dif==min(dif));
betahat = beta(i);

end

