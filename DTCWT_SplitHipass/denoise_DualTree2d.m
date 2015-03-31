function y = denoise_DualTree2d(x,J, sigmaN, FS_filter2d, filter2d)
% Local Adaptive Image Denoising Algorithm
% Usage :
%        y = denoising_dtdwt(x)
% INPUT :
%        x - a noisy image
% OUTPUT :
%        y - the corresponding denoised image

% Set the windowsize and the corresponding filter
windowsize  = 7;
windowfilt = ones(1,windowsize)/windowsize;

% Number of Stages
%J = 4;
I=sqrt(-1);

% symmetric extension
L = length(x); % length of the original image.
%N = L+2^J;     % length after extension.
%x = symextend(x,2^(J-1));
buffer_size = L/2;
%x = symextend(x,buffer_size);
x = symext(x,buffer_size);


load nor_dualtree_noise    % run ComputeNorm_noise to generate this mat file.


% Forward dual-tree DWT
% Either FSfarras or AntonB function can be used to compute the stage 1 filters  
%[Faf, Fsf] = FSfarras;
% [Faf, Fsf] = AntonB;
% [af, sf] = dualfilt1;
% W = cplxdual2D(x, J, Faf, af);
% W = normcoef(W,J,nor);

W = DualTree2d(x, J, FS_filter2d, filter2d);

W = normcoef(W,J,nor);


% Noise variance estimation using robust median estimator..
%tmp = W{1}{1}{1}{1};
Nsig = sigmaN;
num_hipass = length(W{1}{1}{1});

for scale = 1:J-1
    for dir = 1:2
        for dir1 = 1:num_hipass
            
            % Noisy complex coefficients
            %Real part
            Y_coef_real = W{scale}{1}{dir}{dir1};
            % imaginary part
            Y_coef_imag = W{scale}{2}{dir}{dir1};
            % The corresponding noisy parent coefficients
            %Real part
            Y_parent_real = W{scale+1}{1}{dir}{dir1};
            % imaginary part
            Y_parent_imag = W{scale+1}{2}{dir}{dir1};
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
            W{scale}{1}{dir}{dir1} = real(Y_coef);
            W{scale}{2}{dir}{dir1} = imag(Y_coef);
            
        end
    end
end

% Inverse Transform
W = unnormcoef(W,J,nor);
y = iDualTree2d(W, J, FS_filter2d, filter2d);

% Extract the image
% ind = 2^(J-1)+1:2^(J-1)+L;
% y = y(ind,ind);
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);


end











