function [ Ssig ] = latent_variance_estimator( noisydata, Nsig, opt, windowsize )
%LATENT_VARIANCE_ESTIMATOR Estimator of the local variance of the latent
%unknown image. Estimator types is chosen by opt.
%
%Input:
%   noisydata:
%       Observed noisy data, inut as a matrix.
%   Nsig:
%       Noise level. Noise is assumed to be i.i.d. Gaussian.
%   opt:
%       Estimator type option. Input as char string. Currently support:
%           1. 'local_soft'
%           2. 'local_soft_m1'
%           3. 'local_soft_m2'
%           4. 'local_soft_m3'
%           5. 'local_soft_m4'
%           6. 'local_soft_m5'
%           7. 'local_soft_m6'
%           8. 'local_iterative'
%   windowsize:
%       See local_variance() function. Default to be 7.
%
%   Note:   This function can accept complex input noisydata. The output would
%           be the variance of its corresponding latent magnitude.
%
% Chenzhe
% Jan, 2016

if nargin == 3
    windowsize = 7;
end

Ssig_noisy = local_variance(noisydata, windowsize);
Wsig = Ssig_noisy.^2;

% Basic simple estimator
Ssig_est = sqrt(max(Wsig-Nsig.^2, eps));

switch lower(opt)  %Different ways to estimate Ssig: local variance of original image
    case('local_soft')
        Ssig = Ssig_est;
    case('local_soft_m1')
        con = 6.0;
        f0 = 0.08032484*con;
        Ssig = sqrt(max(Ssig_est.^2 - f0*Nsig.^2, eps));
    case('local_soft_m2')
        f0 = 0.08032484;
        c = 5/16;
        Ssig = sqrt( max(Ssig_est.^2 - f0* Nsig.^2, eps)./(1-c) );
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
        
    case('local_iterative') % iterative thresholding
        Ssig = Ssig_noisy;
        
    otherwise
        error('No such case!\n');
        
end






end

