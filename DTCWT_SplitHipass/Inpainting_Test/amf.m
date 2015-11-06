function[varargout] = amf(xo,y,k,pd,recursive)
% adaptive median filter of (2k+1)-by-(2k+1) window for removing
% salt-and-pepper noise
% see Gonzalez, Digital Image Processing, 2nd Edition, Ch 5.3
% xo = noisyfree image (optional)
% y = noisy image 
% set the threshold pd = 0 at this moment
% recursive = 1 indicates the recursive median filter is adopted, while
% recursive = 0 indicates no recursion

if nargin < 5    
    recursive = pd;
    pd = k;
    k = y;
    y = xo;
end


[m,n]=size(y);
y = [y(:,k:-1:1) y y(:,n:-1:n-k+1)];
y = [y(k:-1:1,:) ; y ; y(m:-1:m-k+1,:)];
index = sparse(m,n);
MM = max(max(y));
mm = min(min(y));
for i=1:m
    for j=1:n
        w = 1;          
        while w <= k
            w2 = 2 * w^2 + 2*w + 1;
            w3 = (2*w+1)^2;
            S = y(i+k-w:i+k+w,j+k-w:j+k+w);
            S = sort(S(:));
            Smed = S(w2);
            Smin = S(1);
            Smax = S(w3);
            
            Smedian(w) = Smed;
            S_set{w} = S;
            
            M = Smax - Smin;
            if (Smed > (Smin + pd )) & ((Smax - pd ) > Smed)
                if (y(i+k,j+k) > Smin + pd ) & (Smax - pd  > y(i+k,j+k))
                    if recursive == 1
                        y(i+k,j+k) = y(i+k,j+k);  % recursive
                    else
                        xr(i,j) = y(i+k,j+k);
                    end
                else
                    if recursive == 1
                        y(i+k,j+k) = Smed;    % recursive
                    else
                        xr(i,j) = Smed;
                    end
                    index(i,j) = 1;
                end
                break
            else
                w = w + 1;
            end
        end
        if w > k            
            %             if abs(y(i+k,j+k) - Smedian(1)) > pd | abs(y(i+k,j+k) - Smedian(k)) > pd
            if recursive == 1
                y(i+k,j+k) = Smedian(k);  % recursive
            else
                xr(i,j) = Smedian(k);
            end
            index(i,j) = 1;
            %             end
        end
        %         if (mod(i,100)==0 & mod(j,100)==0)
        %             disp(['iter: ',num2str(i),', ',num2str(j)]);            
        %         end
    end
end

if recursive == 1
    xr = y(k+1:k+m,k+1:k+n);  % output of recursive
end
if nargout == 2
    varargout{1} = xr;
    varargout{2} = index;
else
    varargout{1} = xr;    
end
% figure;
% image(xr);
% colormap(repmat((0:255)'/255,1,3));
% axis image
% kk = 2*k+1;
% if nargin == 5
%     heading = ['adaptive median, ',num2str(kk),' by ',num2str(kk),'window, error=',num2str(norm(xr-xo,'fro')/(m*n))];
% else
%     heading = ['adaptive median, ',num2str(kk),' by ',num2str(kk),' window'];
% end
% title(heading)
% % axis off
% % file_name=['amf_',num2str(kk),'.eps'];
% % print(gcf,'-deps',file_name);
% 
