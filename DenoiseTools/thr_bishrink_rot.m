function thr_coef = thr_bishrink_rot(coef,sigma_n,dir)

%set the window size and the corresponding filter
% windowsize = 7;
% windowfilt = zeros(windowsize); windowfilt(3:5,:) = 1;
% windowfilt = windowfilt/windowsize.^2;
windowsize = 5;
windowfilt = zeros(windowsize); windowfilt(1:5,:) = 1;
windowfilt = windowfilt/windowsize.^2;

n_Lvl = length(coef)-1;

Nsig = sigma_n; % estimation sigma of noise

thr_coef = coef;
for scale = 1:n_Lvl-1
   L = length(coef{scale});
   for l  = 1:L
            Y_coef = coef{scale}{l};
            Y_parent = coef{scale+1}{l};
            %extend noisy parent matrix to make it
            %the same size as the coef matrix
            %Y_parent = fexpand(Y_parent,2);
            Y_parent = expand(Y_parent);
            % signal variance estimation
            rotwinfilt = imrotate(windowfilt,dir{scale}{l},'bilinear','crop');
            Wsig = conv2((abs(Y_coef)).^2,rotwinfilt,'same');
            Ssig = sqrt(max(Wsig - Nsig.^2, eps));
            %threshold value estimation
            T = sqrt(3)*Nsig^2./Ssig;
            % bivariate shrinkage
            Y_coef = bishrink(Y_coef, Y_parent, T);
            thr_coef{scale}{l} = Y_coef;
   end
end

end