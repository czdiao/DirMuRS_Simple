function y = isymext(extImg,Num)
%% Inverse of symext
% Cut the middle part of a symmetric extension image
%
% 
[m,n] = size(extImg);
ind = Num+1:n-Num;
y = extImg(ind,ind);

end