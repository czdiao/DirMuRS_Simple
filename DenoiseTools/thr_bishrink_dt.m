function thr_coef = thr_bishrink_dt(coef,Nsig)
% Bivariate Shrinkage function for Dual Tree CWT coefficients
% Input:
%	coef:	coefficients of DT-CWT, normalized
%	Nsig:	noise level
% Output:
%	thr_coef:	denoised coefficients
% Author:   Chenzhe


windowsize  = 7;
windowfilt = ones(1,windowsize)/windowsize;

I=sqrt(-1);

J = length(coef)-1;

for scale = 1:J-1
    for dir = 1:2
	num_hipass = length(coef{scale}{1}{dir});
        for dir1 = 1:num_hipass
            
            % Noisy complex coefficients
            %Real part
            Y_coef_real = coef{scale}{1}{dir}{dir1};
            % imaginary part
            Y_coef_imag = coef{scale}{2}{dir}{dir1};
            % The corresponding noisy parent coefficients
            %Real part
            Y_parent_real = coef{scale+1}{1}{dir}{dir1};
            % imaginary part
            Y_parent_imag = coef{scale+1}{2}{dir}{dir1};
            % Extend noisy parent matrix to make the matrix size the same as the coefficient matrix.
            Y_parent_real  = expand(Y_parent_real);
            Y_parent_imag   = expand(Y_parent_imag);
                        
            
            % Signal variance estimation
            Wsig = conv2(windowfilt,windowfilt,(Y_coef_real).^2,'same');
            Ssig = sqrt(max(Wsig-Nsig.^2,eps));
            
            % Threshold value estimation
            T = sqrt(6)*Nsig^2./Ssig;
            
            % Bivariate Shrinkage
            Y_coef = Y_coef_real+I*Y_coef_imag;
            Y_parent = Y_parent_real + I*Y_parent_imag;
            
            Y_coef = bishrink(Y_coef,Y_parent,T);
            coef{scale}{1}{dir}{dir1} = real(Y_coef);
            coef{scale}{2}{dir}{dir1} = imag(Y_coef);
            
        end
    end
end

thr_coef = coef;

end
