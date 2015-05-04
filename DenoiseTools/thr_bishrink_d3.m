function thr_coef = thr_bishrink_d3(coef,sigma_n)

%set the window size and the corresponding filter
windowsize = 3;
windowfilt = ones(1,windowsize)/windowsize;
[wfx,wfy,wfz] = meshgrid(windowfilt,windowfilt,windowfilt);
windowfilt = wfx.*wfy.*wfz;

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
            Y_parent = expand_d3(Y_parent);
            % signal variance estimation
            Wsig = convn((abs(Y_coef)).^2,windowfilt,'same');           
            Ssig = sqrt(max(Wsig - Nsig.^2, eps));
            %threshold value estimation
            T = 2*sqrt(3)*Nsig^2./Ssig;  
            % bivariate shrinkage
            Y_coef = bishrink_d3(Y_coef, Y_parent, T);
            thr_coef{scale}{l} = Y_coef;
   end
end
    

end