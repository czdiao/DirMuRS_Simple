function r = fixNegEigs(C)
% fixNegEigs : enforce positive definiteness of matrix
%
% r=fixNegEigs(C)
%
% Take a symmetric matrix and 'correct' negative eigenvalues by
% diagonalizing and setting negative diagonal elements to a small
% positive number. Normalize so that returned answer will have same
% trace.
%
% Inputs:
% C - input symmetric matrix
%
% Outputs:
% r - returned positive definite matrix 

[U L]=eig(C);
dL=diag(L);
dLsum=sum(dL); % sum of eigenvalues of C
dL1=dL.*(dL>0)+1e-10*(dL<=0);
dL1=dL1*abs(dLsum/sum(dL1)); % force L1 to have same sum
L1=diag(dL1);
r=U*L1*U';
if det(r)<0
  fprintf('Negative determinant [ %g ] in fixNegEigs\n',det(r));
  if abs(det(r))>1
    %keyboard
  end
end

% [Q,L] = eig(C);
% % correct possible negative eigenvalues, without changing the overall variance
% L = diag(diag(L).*(diag(L)>0))*sum(diag(L))/(sum(diag(L).*(diag(L)>0))+(sum(diag(L).*(diag(L)>0))==0));
% r2 = Q*L*Q';
% % rdiff = max(abs(vec(r-r2)));
% 
% r=r2; % switch to other way ....
% %fprintf('fixNegEigs switched\n');

