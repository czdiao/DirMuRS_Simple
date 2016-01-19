function [ thr_coef ] = localsoft_test( coef,coef_true,sigma_n, nor, opt )
%LOCALSOFT_TEST Summary of this function goes here
%   Detailed explanation goes here



n_Lvl      = length(coef)-1;

coef = normcoef_dt(coef,n_Lvl,nor);
coef_true = normcoef_dt(coef_true, n_Lvl, nor);

Nsig       = sigma_n; % estimation sigma of noise

thr_coef   = coef;
for scale  = 1:n_Lvl-1    
    for d1 = 1:2
        for d2 = 1:2
            L      = length(coef{scale}{d1}{d2});
            
            for l  = 1:L %bands
                Y_coef = coef{scale}{d1}{d2}{l};
                
                % Estimated variance
                windowsize = 7;
                windowfilt = ones(1,windowsize)/windowsize;
                Wsig = conv2(windowfilt,windowfilt,(abs(Y_coef)).^2,'same');
                Ssig_est = sqrt(max(Wsig - Nsig.^2, eps));
                
                % True Variance
                Y_coef_true = coef_true{scale}{d1}{d2}{l};
                Wsig_true = conv2(windowfilt,windowfilt,(abs(Y_coef_true)).^2,'same');
                Ssig_true = max(sqrt(Wsig_true), eps);
                
                
                
                switch lower(opt)  %Different ways to estimate Ssig: local variance of original image
                    case('local_soft')
                        Ssig = Ssig_est;
                    case('local_true')
                        Ssig = Ssig_true;
                    case('local_soft_m1')
                        con = 6.0;
                        f0 = 0.08032484*con;
                        Ssig = sqrt(max(Ssig_est.^2 - f0*Nsig.^2, eps));
                    case('local_soft_m2')
                        f0 = 0.08032484;
                        c = 5/16;
                        Ssig = sqrt( max(Ssig_est.^2 - f0*Nsig.^2, eps)./(1-c) );
                        Ssig = min(Ssig, Ssig_est);
                    case('local_soft_m3')
                        lambda1 = 0.4;
                        lambda2 = 1;
                        alpha = 1.8;
                        Ssig_tmp1 = Ssig_est.*(Ssig_est>lambda2*Nsig);
                        Ssig_tmp2 = max((Ssig_est-lambda1*Nsig)/Nsig/(lambda2-lambda1), eps);
                        Ssig_tmp2 = Nsig*lambda2 * Ssig_tmp2.^alpha;
                        Ssig_tmp2 = Ssig_tmp2 .* (Ssig_est <= lambda2*Nsig);
                        Ssig = Ssig_tmp1 + Ssig_tmp2;
                        Ssig = max(Ssig, eps);
                    case('local_soft_m4')   % cubic fitting!
                        lambda1 = 0.4;  %0.4
                        lambda2 = 1.2;  %1.2
                        Ssig_tmp1 = Ssig_est.*(Ssig_est>lambda2*Nsig);
                        
                        b = (2*lambda2+lambda1)/Nsig/(lambda2-lambda1)^2;
                        a = -(lambda1+lambda2)/Nsig^2/(lambda2-lambda1)^3;
                        Ssig_tmp2 = a*(Ssig_est - lambda1*Nsig).^3 + b*(Ssig_est - lambda1*Nsig).^2;
                        Ssig_tmp2 = Ssig_tmp2 .* (Ssig_est<=lambda2*Nsig) .* (Ssig_est > lambda1*Nsig);
                        Ssig = Ssig_tmp1 + Ssig_tmp2;
                        Ssig = max(Ssig, eps);
                    case('local_soft_m5')   % hyperbolic
                        lambda1 = 0.3;
                        lambda2 = 1.3;
                        alpha = 1;
                        Ssig_est = Ssig_est./Nsig;
                        Ssig_tmp1 = Ssig_est.*(Ssig_est>lambda2);
                        Ssig_tmp2 = (Ssig_est.^2-lambda1^2).*(Ssig_est<=lambda2);
                        Ssig_tmp2 = Ssig_tmp2.*(Ssig_tmp2>0);
                        Ssig_tmp2 = Ssig_tmp2.^alpha * (lambda2/(lambda2^2-lambda1^2)^alpha);
                        Ssig = Ssig_tmp1 + Ssig_tmp2;
                        Ssig = max(Ssig, eps);
                        Ssig = Ssig.*Nsig;
                        
                    case('local_soft_m6')   % expectation
                        lambda = log(Nsig/5)/log(20);
                        Wsig = Wsig/Nsig^2;
                        Ssig_est = Ssig_est/Nsig;
                        
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % sigma = 5
                        p1_5 = 0.51727;
                        p2_5 = -0.70206;
                        p3_5 = 0.60501;
                        p4_5 = 0;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        xt = sqrt(Wsig);
                        yt_5 = p1_5*xt.^3 + p2_5*xt.^2 + p3_5*xt + p4_5;
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % sigma = 100
                        p1_100 = 0.61518;
                        p2_100 = -0.74155;
                        p3_100 = 0.079357;
                        p4_100 = 0.14962;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                        yt_100 = p1_100*xt.^4 + p2_100*xt.^3 + p3_100*xt.^2 + p4_100*xt;
                        
                        %                 yt_5 = SigmaBM(Wsig, 5);
                        %                 yt_100 = SigmaBM(Wsig, 100);
                        
                        Ssig_tmp1 = Ssig_est.*(Wsig>=2.7);
                        Ssig_tmp2 = lambda*yt_100 + (1-lambda)*yt_5;
                        Ssig_tmp2 = Ssig_tmp2.*(Wsig<2.7);
                        %                 Ssig_tmp2 = Ssig_tmp2.*(Wsig>1.4);
                        Ssig = Ssig_tmp1 + Ssig_tmp2;
                        Ssig = Ssig*Nsig;
                        Ssig = max(Ssig, eps);
                        
                    case('local_beta')
                        % True beta
                        load('rtable.mat', 'r', 'beta');
                        betahat = zeros(size(Y_coef_true));
                        for ii = ceil(windowsize/2):size(Y_coef_true, 1)-floor(windowsize/2)
                            for jj = ceil(windowsize/2):size(Y_coef_true, 2)-floor(windowsize/2)
                                data = Y_coef_true(ii-3:ii+3,jj-3:jj+3);
                                betahat(ii,jj) = Calbeta(data(:), length(data(:)),r, beta );
                            end
                        end
                        
                        ratio = (0.102*betahat-0.121).*(Ssig_true./Nsig).^2 + (-0.872*betahat+1.036).*Ssig_true./Nsig+(0.48*betahat+0.33);
                        Ssig = Ssig_true./ratio;
                        
                    case('local_beta2') % local sigma, beta for one band
                        load('rtable.mat', 'r', 'beta');
                        data = Y_coef_true;
                        betahat = Calbeta(data(:), length(data(:)),r, beta );
                        ratio = (0.102*betahat-0.121).*(Ssig_true./Nsig).^2 + (-0.872*betahat+1.036).*Ssig_true./Nsig+(0.48*betahat+0.33);
                        Ssig = Ssig_true./ratio;
                        
                    case('local_iterative') % iterative thresholding
                        Ssig = sqrt(Wsig);
                        
                    otherwise
                        error('No such case!\n');
                        
                end
                
                
                %threshold value estimation
                T    = Nsig^2./Ssig;
                
                % local-soft shrinkage
                Y_coef = (abs(Y_coef) >= T).*(Y_coef-T.*Y_coef./abs(Y_coef));
                thr_coef{scale}{d1}{d2}{l} = Y_coef;
            end %bands
        end %tree2
    end %tree1
end %level

thr_coef = unnormcoef_dt(thr_coef,n_Lvl,nor);




end

