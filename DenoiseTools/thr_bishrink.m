function thr_coef = thr_bishrink(coef,sigma_n)
% Bivariate Shrinkage for Framelet Coefficients

%set the window size and the corresponding filter
windowsize = 7;
windowfilt = ones(1,windowsize)/windowsize;

n_Lvl = length(coef)-1;

Nsig = sigma_n; % estimation sigma of noise

thr_coef = coef;
for scale = 1:n_Lvl-1
   L = length(coef{scale});
   for l  = 1:L
            Y_coef = coef{scale}{l};
            Y_parent = coef{scale+1}{l};
            %extend parent matrix to make it the same size
            
            %Y_parent = fexpand(Y_parent,2);
            Y_parent = expand(Y_parent);
            % signal variance estimation
            Wsig = conv2(windowfilt,windowfilt,(abs(Y_coef)).^2,'same');           
            Ssig = sqrt(max(Wsig - Nsig.^2, eps));
            %threshold value estimation
            T = Nsig^2./Ssig;  

            % bivariate shrinkage
            Y_coef = bishrink(Y_coef, Y_parent, T);

            thr_coef{scale}{l} = Y_coef;
   end
end
    

end
