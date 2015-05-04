function thr_coef = thr_bishrink_2(coef,coef_parent,sigma_n,c)

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
            
            windowfilt2 = 1/(n_Lvl-scale)*ones(1,n_Lvl-scale);
            windowfilt2 = 1/2*ones(1,2);
            Y_parent = coef_parent{scale}{l};
            Y_parent = conv2(windowfilt2,windowfilt2,Y_parent,'same');
            Y_parent = d2dwnsmpl(Y_parent,2,2,0,0);
            
            % signal variance estimation
            Wsig = conv2(windowfilt,windowfilt,(abs(Y_coef)).^2,'same');           
            Ssig = sqrt(max(Wsig - Nsig.^2, eps));
            %threshold value estimation
            T = sqrt(2)*Nsig^2./Ssig;  
            % bivariate shrinkage
            Y_coef = bishrink_c(Y_coef, Y_parent, T,c);
            thr_coef{scale}{l} = Y_coef;
   end
end
    

end