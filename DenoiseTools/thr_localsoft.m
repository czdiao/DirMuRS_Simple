function thr_coef = thr_localsoft(coef,sigma_n,c,opt)

if nargin == 2
    c = 1;
end
if nargin == 3
    opt = 'local_soft';
end

%set the window size and the corresponding filter


n_Lvl      = length(coef)-1;
Nsig       = sigma_n; % estimation sigma of noise

thr_coef   = coef;
for scale  = 1:n_Lvl-1
    L      = length(coef{scale});
    for l  = 1:L
        Y_coef = coef{scale}{l};
     
        switch lower(opt)
            case('local_soft')
                windowsize = 7;
                windowfilt = ones(1,windowsize)/windowsize;
                % signal variance estimation
                Wsig = conv2(windowfilt,windowfilt,(abs(Y_coef)).^2,'same');
                Ssig = sqrt(max(Wsig - Nsig.^2, eps));
            case('local_adapt')
                windowsize = 9;
                windowfilt = ones(1,windowsize)/windowsize;
                % signal variance estimation
                Wsig = conv2(windowfilt,windowfilt,(abs(Y_coef)),'same');
                Ssig = sqrt(max(Wsig.^2 - Nsig.^2, eps));
        end
        %threshold value estimation
        T    = c*Nsig^2./Ssig;
        
        % local-soft shrinkage
        Y_coef = (abs(Y_coef) >= T).*(Y_coef-T.*Y_coef./abs(Y_coef)); 
        thr_coef{scale}{l} = Y_coef;
    end
end


end