function [ az ] = FejerRieszReal( P )
%FEJERRIESZREAL Solve Fejer Riesz for real polynomials.
%   If a(z) is a real Laurant Polynomial (filter), then a(z)a^*(z) is a
%   real symmetric filter. So there exists 'real' polynomial P(x), s.t.
%           a(z)a^*(z) = P(sin^2(\xi/2))
%   Here, a(z) is a lowpass filter, which means P(0)=\hat{a}(0)=1.
%   Also, we know that P >=0 on [0,1].
%   We don't require P(1)=0.
%
% Input:
%   P:  Polynomial (row vector) in terms of x = sin^2(\xi/2)
%
% Output:
%   az: Laurant Polynomial (filter1d)
%
%   Chenzhe
%   Nov. 2015


az = filter1d(1,0); % initialized to be dirac filter

% Find the roots of P by symbolic computation
r = roots(P);
% syms x eqn;
% eqn = 0;
% degP = length(P)-1;
% for dd = degP:(-1):0
%     eqn = eqn + P(degP-dd+1) * x^dd;
% end
% r = double(solve(eqn, x));



k = 1;
while k <= length(r)
    if abs(imag(r(k)))<=abs(r(k))*1e-10  % real root
        r(k) = real(r(k));
        if r(k)>=(1-1e-7) || (r(k)<0)  % real root not on [0,1)
            rr = 1-2*r(k)+2*sqrt(r(k)^2-r(k));
            az = az.convfilter(filter1d([-rr, 1],0));   %add factor: (z-rr)
            c = 1/(1-rr);
            az = c.*az;
        else    % real root in (0,1), comes in pair
            % find multiplicity of the roots, should be even
            multiplicity = 1;
            for kk = (k+1):length(r)
                if abs(r(kk)-r(k))<=eps
                    multiplicity = multiplicity +1;
                    r(kk) = [];
                end
            end
            if mod(multiplicity,2)~=0
                error('Wrong Multiplicity in number of real roots!');
            end
            multiplicity = multiplicity/2;
            t = 1/r(k);
            % take half of (1-t*x) factors
            for ii = 1:multiplicity
                az = az.convfilter(filter1d([t/4, 1-t/2, t/4],-1));
            end
            
        end %end 2 cases for real roots
        
    else    % complex root pair
        % find its conjugate pair
        kk = k+1;
        while abs(r(kk)-conj(r(k)))>abs(r(k))*1e-10
            kk = kk+1;
        end
        r(kk) = [];
        rr = roots([1, 4*r(k)-2, 1]);
        rr = rr(1);
        x_tilde = -2*real(rr);
        y_tilde = abs(rr)^2;
        az = az.convfilter(filter1d([y_tilde, x_tilde, 1],0));
        az = 1/(1+x_tilde + y_tilde) .* az;
    end
    
    
    k = k+1;
end


az = az.Real;
c = sum(az.filter);
az = 1/c.*az;

end

