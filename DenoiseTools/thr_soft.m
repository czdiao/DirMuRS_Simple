function thr_coef = thr_soft(coef)
%% soft thresholding
% windowsize = 7;
% windowfilt = ones(1,windowsize)/windowsize;

n_Lvl = length(coef)-1;
thr_coef = coef;

for scale = 1:n_Lvl
   L = length(coef{scale});
   for l  = 1:L
            Y_coef = coef{scale}{l};
            %threshold value estimation
            N = numel(Y_coef);
            sig = NoiseLevel(Y_coef); % may be wrong for cplx value!!
            T = 2*sqrt(N)*sig;  
            % soft shrinkage
            Y_coef = soft(Y_coef, T);
            thr_coef{scale}{l} = Y_coef;
   end
end
    

end