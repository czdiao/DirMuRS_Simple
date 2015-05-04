function thr_coef = thr_BLSGSM2(coef,Crw,Ciw,params)

% This code implements the Gaussian scale mixture (GSM) or projected mixture
% of Gaussian scale mixture (PMGSM) for DECIMATED Tensor product complex tight
% framelets (TP-CTF) with precalculated noise covariance matrix (Crw, Ciw).
%
% Run Test_Noise_Covariance to generate noise covariance matrix!
% Saved Cw structure:
% Cw{1/2: real/imaginary part}{1/2/3/4/5/6: sigmaN = 10/15/20/25/30/50}
%
% The the calculation of decimated version the noise covariance (C_w) by 
% decomposing dirac impusle is NOT right.
%
% Inputs: 
%       coef  : all the noisy coef bands (multi-scale)
%       Crw, Ciw: the real and imag part of noise cov matrice (multi-scale)
%       params  : denoising params struct includes:
%              params.block = [3 3]; % block size
%              params.optim = 1;
%              params.parent = 0; % use parent or not (1/0)
%              params.covariance = 1;
%       sigma_n : noise standard deviation
% Outputs:
%       thr_coef : all the denoised coef bands

%%
n_Lvl = length(coef)-1;
prnt = params.parent;

thr_coef = coef;   % preallocate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set parameters for controlling integration over z
logzmin = -20.5; logzmax = 3.5; Nz = 13;
logz_list = linspace(logzmin,logzmax,Nz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for scale = 1:n_Lvl % should be n_Lvl
    fprintf('\nDenoising scale %g\n',scale);
    L = length(coef{scale});
    for l = 1:L/2
        fprintf('band: %g and %g \n',l,L+1-l);
        Y_coef = coef{scale}{l}; bdim = size(Y_coef);
        BL = zeros(bdim(1),bdim(2),1+prnt);
        BL(:,:,1) = Y_coef;  
        
        if prnt,           
            Y_parent = coef{scale+1}{l};            
            if (params.dwnsmpl_low(scale) == 1) && (params.dwnsmpl_high(scale) == 1)
                BL(:,:,2)  = real(fexpand(Y_parent,2));       
            end
        end    
        % main
          % Test: MPGSM for BLSGSM7 and MGSM for BLSGSM8
        if  1
           Y_coef_real = BLSGSM5(real(BL),Crw{scale}{l},logz_list,params);
           Y_coef_imag = BLSGSM5(imag(BL),Ciw{scale}{l},logz_list,params);
           thr_coef{scale}{l}     = Y_coef_real + 1i*Y_coef_imag;         
           thr_coef{scale}{L+1-l} = Y_coef_real - 1i*Y_coef_imag;
           
        else
           Y_coef_real = BLSGSM8(real(BL),Crw{scale}{l},logz_list,params);
           Y_coef_imag = BLSGSM8(imag(BL),Ciw{scale}{l},logz_list,params);
           thr_coef{scale}{l}     = Y_coef_real + 1i*Y_coef_imag;
           thr_coef{scale}{L+1-l} = Y_coef_real - 1i*Y_coef_imag;
        end
        
%         % Choice 1: p(z) is noninformative (Jeffrey) prior
%         Y_coef_real = BLSGSM5(real(BL),Crw{scale}{l},logz_list,params);
%         Y_coef_imag = BLSGSM5(imag(BL),Ciw{scale}{l},logz_list,params);
%         thr_coef{scale}{l} = Y_coef_real + 1i*Y_coef_imag;

%         % Choice 2: p(z) is lognormal density
%         Y_coef_real = BLSGSM3(real(BL),Crw{scale}{l},logz_list,params);
%         Y_coef_imag = BLSGSM3(imag(BL),Ciw{scale}{l},logz_list,params);
%         thr_coef{scale}{l} = Y_coef_real + 1i*Y_coef_imag;
        
%         % Choice 3: p(z) is Gau-Hermite density
%         Y_coef_real = BLSGSM4(real(BL),Crw{scale}{l},logz_list,params);
%         Y_coef_imag = BLSGSM4(imag(BL),Ciw{scale}{l},logz_list,params);
%         thr_coef{scale}{l} = Y_coef_real + 1i*Y_coef_imag;

    end
end

end