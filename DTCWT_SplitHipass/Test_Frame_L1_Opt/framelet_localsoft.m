function [ y ] = framelet_localsoft(x, x_true,J, sigmaN, FS_filter1d, fb1d, nor, Transform, method, varargin)
%DENOISE_BISHRINK Denoising using Bivariate Shrinkage + DT based transforms.
% Local Adaptive Image Denoising Algorithm
%
% Examples:
%   1)  For DT-CWT
%       y = denoise_BiShrink_new(x,J, sigmaN, FS_filter1d, fb1d, nor, 'DT')
%   2)  For DT-CWT Split Highpass
%       y = denoise_BiShrink_new(x,J, sigmaN, FS_filter1d, fb1d, nor, 'DT_SplitHigh', u_hi)
%   3)  For DT-CWT Split both Highpass and lowpass
%       y = denoise_BiShrink_new(x,J, sigmaN, FS_filter1d, fb1d, nor, 'DT_SplitHighLow', u_hi, u_low)
%
%
% INPUT :
%        x:
%           a noisy image
%        J:
%           level of decomposition
%        sigmaN:
%           noise level.
%        FS_filter1d:
%           First stage filter banks.
%        fb1d:
%           filter banks for both trees.
%        nor:
%           norm of the multi-level filters.
%        Transform:
%           'DT', 'DT_SplitHigh', 'DT_SplitHighLow'
%
% Optional Input:
%        varargin{1}:
%           u_hi(2), 2 filters to split the highpass filters.
%        varargin{2}:
%           u_low(2), 2 filters to split the lowpass filters.
%
% OUTPUT :
%        y - the corresponding denoised image
%
%   Chenzhe Diao
%   Sept, 2015



% symmetric extension
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);
x_true_ext = symext(x_true, buffer_size);


switch Transform  % Set WaveDec1(x) and WaveRec1(W) function for different Transforms
    case('DT')
        WaveDec1 = @(xt) DualTree2d(xt, J, FS_filter1d, fb1d);
        WaveRec1 = @(Wt) iDualTree2d(Wt, J, FS_filter1d, fb1d);
    case('DT_SplitHigh')
        u_hi = varargin{1};
        WaveDec1 = @(xt) DualTree2d_SplitHigh(xt, J, FS_filter1d, fb1d, u_hi);
        WaveRec1 = @(Wt) iDualTree2d_SplitHigh(Wt, J, FS_filter1d, fb1d, u_hi);
    case('DT_SplitHighLow')
        u_hi = varargin{1};
        u_low = varargin{2};
        WaveDec1 = @(xt) DualTree2d_SplitHighLow(xt, J, FS_filter1d, fb1d, u_hi, u_low);
        WaveRec1 = @(Wt) iDualTree2d_SplitHighLow(Wt, J, FS_filter1d, fb1d, u_hi, u_low);
    case('DT_SplitHighLowComplex')
        u_hi = varargin{1};
        u_low = varargin{2};
        WaveDec1 = @(xt) DualTree2d_SplitHighLowComplex(xt, J, FS_filter1d, fb1d, u_hi, u_low);
        WaveRec1 = @(Wt) iDualTree2d_SplitHighLowComplex(Wt, J, FS_filter1d, fb1d, u_hi, u_low);
    otherwise
        error('Unknown Transform type!');
end

WaveDec = @(xt) WaveletData2D(WaveDec1(xt), 'DualTree');
WaveRec = @(Wt) WaveRec1(Wt.coeff);
W_true = WaveDec(x_true_ext);

switch method
    
    case 'local_soft'
        %%Local Soft
        
        %Wavelet Decomposition
        W = WaveDec1(x);
        
        W = localsoft_test(W, W_true.coeff, sigmaN, nor,'local_true');
        
        %Wavelet Reconstruction
        y = WaveRec1(W);
        
        % Extract the image
        ind = buffer_size+1 : buffer_size+L;
        y = y(ind,ind);

    case 'iter1'
        %%Iterative Soft-Thresholding:  Balanced Approach
        % As Algorithm 2 (3.19) from the paper:
        % "FRAMELET BASED DECONVOLUTION" by Jianfeng Cai, Zuowei Shen
        
        mu = 5;
        W = WaveDec(x);
        y = x;
        residue = 10;
        tol = 0.1;
        niter = 0;
        
        while (residue>tol)&&(niter<1000)
            W_Ker = W - WaveDec(y);     % The orthogonal part in transform kernel
            fidelity = x - y;
            
            % Step 1
            W = W - mu.*W_Ker + WaveDec(fidelity);
            % Step 2
            W.coeff = localsoft_test(W.coeff, W.coeff, sigmaN, nor, 'local_soft');
            
            y_new = WaveRec(W);
            residue = sqrt(sum(sum((y_new-y).^2)));     % l2 error in image domain
            y = y_new;
            
            fprintf('\nThe residue in step %d is %g', niter, residue);
            niter = niter + 1;
        end
        
        % Extract the image
        ind = buffer_size+1 : buffer_size+L;
        y = y(ind,ind);
        
    case 'iter2'
        %%Iterative local soft
        t_range = [1, 0.8, 0.5, 0.3, 0.2, 0.1];
        yn = x;
        for t = t_range
            s = t*x + (1-t)*yn;
            
            W = WaveDec1(s);
            W = localsoft_test(W, W, sigmaN*t, nor,'local_soft');
            yn = WaveRec1(W);
            
            % Extract the image
            ind = buffer_size+1 : buffer_size+L;
            y = yn(ind,ind);
            y = max(y, 0);
            y = min(y, 255);
            pval = PSNR(x_true, y);
            fprintf('\nt = %f, PSNR = %f', t, pval);
            
        end
        
    case 'iter_SplitBregman'
        %%Iterative SplitBregman algorithm, solving the analysis based
        %model.
        
        %Initialization
        lambda = 1;
        delta = 1;
        
        %Wavelet Decomposition
        W = WaveDec(x);
        W.coeff = localsoft_test(W.coeff, W_true.coeff, sigmaN, nor,'local_true');        
        %Wavelet Reconstruction
        y = WaveRec(W);
        % Extract the image
        ind = buffer_size+1 : buffer_size+L;
        y_reshape = y(ind,ind);
        y_reshape = max(y_reshape, 0);
        y_reshape = min(y_reshape, 255);
        pval = PSNR(x_true, y_reshape);
        fprintf('\nInitial: PSNR = %f', pval);
        t = sprintf('Result after local soft, PSNR = %f', pval);
        figure;ShowImage(y_reshape); title(t);

        
        b = W - W;
        tol = 0.1;
        rel_err = 10;
        niter = 0;
        
        %%Iteration
        while (rel_err>tol)&&(niter<15)

            %%step 1
            y = 1/(1+lambda) * (x + lambda * WaveRec(W-b));
            %%step 2
            tmp1 = WaveDec(y);
            tmp = tmp1 + b;
            W.coeff = localsoft_test(tmp.coeff, W_true.coeff, sigmaN/sqrt(lambda), nor, 'local_true');
            %%step 3
            b = b + delta .* (tmp1 - W);
            niter = niter + 1;
            
            %%Check PSNR
            ind = buffer_size+1 : buffer_size+L;
            y_new = y(ind,ind);
            y_new = max(y_new, 0);
            y_new = min(y_new, 255);
            pval = PSNR(x_true, y_new);
            rel_err = max(max(abs(y_new - y_reshape)));
            y_reshape = y_new;
            E = energyL1(y_reshape, x_true, W, sigmaN, W_true);
            
            fprintf('\nIteration = %d: PSNR = %f, rel_error = %f, E = %f',niter, pval, rel_err, E);
            
        end
        
        y = y_reshape;
        
    case 'iter_SplitBregman_magnitude'
        %%Iterative SplitBregman, solving analysis based model
        %Make the optimization model based on the magnitude for the complex
        %framelets.
        
        %%Initialization
        lambda = 1;
        delta = 0.5;
        Ssig = localsigma_magnitude_dt( W_true );   %use true local sigma for comparison
        
        %Wavelet Decomposition
        W = WaveDec(x);
        W = localsoft_mag(W, Ssig, sigmaN);        
        %Wavelet Reconstruction
        y = WaveRec(W);
        % Extract the image
        ind = buffer_size+1 : buffer_size+L;
        y_reshape = y(ind,ind);
        y_reshape = max(y_reshape, 0);
        y_reshape = min(y_reshape, 255);
        pval = PSNR(x_true, y_reshape);
        fprintf('\nInitial: PSNR = %f', pval);
        
        b = W - W;
        tol = 0.1;
        rel_err = 10;
        niter = 0;
        
        %%Iteration
        while (rel_err>tol)&&(niter<10)

            %%step 1
            y = 1/(1+lambda) * (x + lambda * WaveRec(W-b));
            %%step 2
            tmp1 = WaveDec(y);
            tmp = tmp1 + b;
            W = localsoft_mag(tmp, Ssig, sigmaN/sqrt(lambda));
            %%step 3
            b = b + delta .* (tmp1 - W);
            niter = niter + 1;
            
            %%Check PSNR
            ind = buffer_size+1 : buffer_size+L;
            y_new = y(ind,ind);
            y_new = max(y_new, 0);
            y_new = min(y_new, 255);
            pval = PSNR(x_true, y_new);
            rel_err = max(max(abs(y_new - y_reshape)));
            y_reshape = y_new;
            E = energyL1(y_reshape, x_true, W, sigmaN, W_true);
            
            fprintf('\nIteration = %d: PSNR = %f, rel_error = %f, E = %f',niter, pval, rel_err, E);
            
        end
        
        y = y_reshape;
    otherwise
        error('Unknown method!');
        
end











end

