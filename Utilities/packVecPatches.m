function patches = packVecPatches(coefband,block)
% packVecPatches : extract vectorized patches from coefficients
% Inputs:
% coefband - coefficients need to be packed
% block - the nbhd size, i.e., [3 3]
% Outputs:
% patches - d x N array of vectorized patches. 
%           d is patch dimension
%           N is the total number of extracted overlapping patches.
%
% For 3x3 patches including 1 parent, then one has d = 3*3 + 1 = 10
%
[M,N] = size(coefband);

child_seg = zeros(block(1)*block(2), M*N);
boundary  = floor(max(block)/2) + 2;
child_e   = extendBoundary(coefband,boundary,'method','reflect');

k = 1;
for m = 1:block(1)
   for n = 1:block(2)
       cb1 = boundary + m - (floor(block(1)/2)+1);
       cb2 = boundary + n - (floor(block(2)/2)+1);
       child_seg(k,:) = vec(child_e((1:M)+cb1,(1:N)+cb2));
       k = k + 1;
   end
end
  
%% NEED TO REWRITE THE COEFBAND STRUCTURE!!!
parent_seg=[];
% if denoise_params.parent,
%   [M N] = size(fullband.parent);
%   parent_seg = zeros((2*K.parent(1)+1)*(2*K.parent(2)+1)*nbands,M*N);
%   boundary = K.pfactor*(max(K.parent)+2);
%   for b=1:nbands
%     parent_e = extendBoundary(fullband.parent(:,:,b),boundary,'method',bdx_m);
%     for m = 1:2*K.parent(1)+1
%       for n = 1:2*K.parent(2)+1
%         pb1 = boundary + K.pfactor*(m-(K.parent(1)+1));
%         pb2 = boundary + K.pfactor*(n-(K.parent(2)+1));
%         k=(b-1)*(2*K.parent(1)+1)*(2*K.parent(2)+1)+(n-1)*(2*K.parent(1)+1)+m;
%         parent_seg(k,:)= vec(parent_e((1:M)+pb1,(1:N)+pb2));
%       end
%     end
%   end
% end
%%
patches=[child_seg;parent_seg];