function thr_coef = thr_BLSGSM(coef,noise,params,sigma_n)

% This code implements the Gaussian scale mixture (GSM) for UNDECIMATED Tensor 
% product complex tight framelets (TP-CTF) with using decompose dirac impulse
% to calculate the noise covariance matrix (C_w).
% Inputs: 
%       coef  : coefficients need to be denoised
%       noise : spectrum of dirac impulse after transform  
%       params: parameters
%          params.block = [3 3]; % block size
%          params.optim = 1;
%          params.parent = 1;
%          params.covariance = 1;
%       sigma_n : noise standard deviation;
% Outputs:
%      thr_coef: denoised coefficients

n_Lvl = length(coef)-1;
sig   = sigma_n;

thr_coef = coef;   % preallocate
for scale = 1:n_Lvl-1
    L = length(coef{scale});
    for l = 1:L
        Y_coef     = coef{scale}{l};
        Y_coef_N   = noise{scale}{l};
        Y_parent   = coef{scale+1}{l};
        Y_parent_N = noise{scale+1}{l};
        [Nsy,Nsx]  = size(Y_coef);
        prnt = params.parent;
        BL   = zeros(size(Y_coef,1),size(Y_coef,2),1 + prnt);
        BLn  = zeros(size(Y_coef,1),size(Y_coef,2),1 + prnt);
        BL(:,:,1)  = Y_coef;
        % because we are discarding 2 coefs both dimension
        BLn(:,:,1) = Y_coef_N*sqrt(((Nsy-2)*(Nsx-2))/(Nsy*Nsx));
        
        if prnt,
           if (params.dwnsmpl_low(scale) == 1) && (params.dwnsmpl_high(scale) == 1)
              % Two ways of expansion
              %BL(:,:,2)  = real(expand(Y_parent));
              %BLn(:,:,2) = real(expand(Y_parent_N))*sqrt(((Nsy-2)*(Nsx-2))/(Nsy*Nsx));
              BL(:,:,2)  = real(fexpand(Y_parent,2));
              BLn(:,:,2) = real(fexpand(Y_parent_N,2))*sqrt(((Nsy-2)*(Nsx-2))/(Nsy*Nsx));
           else
              BL(:,:,2)  = real(Y_parent);
              BLn(:,:,2) = real(Y_parent_N)*sqrt(((Nsy-2)*(Nsx-2))/(Nsy*Nsx));
           end
        end
                
        % main
%       %choice 1: treat the coefficients as cplx numbers
%         Y_coef = BLSGSM(BL,BLn,params,sig);
%         thr_coef{scale}{l} = Y_coef;
        
        %choice 2: do the GSM for real and imag separately!
%         Y_coef_real = BLSGSM(real(BL),real(BLn),params,sig);
%         Y_coef_imag = BLSGSM(imag(BL),imag(BLn),params,sig);
%         thr_coef{scale}{l} = Y_coef_real + 1i*Y_coef_imag;

        % choice 3:
        logzmin = -20.5; logzmax = 3.5; Nz = 13;
        logz_list = linspace(logzmin,logzmax,Nz);

        Y_coef_real = BLSGSM9(real(BL),real(BLn),logz_list, params);
        Y_coef_imag = BLSGSM9(imag(BL),imag(BLn),logz_list, params);
        thr_coef{scale}{l} = Y_coef_real + 1i*Y_coef_imag;

    end
end

end