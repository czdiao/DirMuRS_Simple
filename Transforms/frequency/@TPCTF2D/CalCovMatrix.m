function [ Cwr, Cwi ] = CalCovMatrix( obj, N, blocksize, fker )
%CALCOVMATRIX Calculate the noise covariance matrix of the decimated
%transform.
%
%Input:
%   N:
%       Size of the signal to calculate the frames. It should be large
%       enough to avoid time domain folding, and small enough to save
%       computational time. For example, for TPCTF6, 5 levels of covariance
%       calculation, N=512 would be probably enough.
%   blocksize:
%       Integer, normally take 3 or 5.
%   ker: (Optional)
%       convolution kernel. 
%
%
%   Used in Gaussian Scale Mixture Denoising.
%
%   If input contains ker:
%       The signal is blurred by the kernel first. So the noise (before 
%       decomposition) has the power spectral the same as the kernel. Then, 
%       in calculation of the covariance matrix of the noise, we need to blur 
%       all the frames with conjugate flip of ker:  conj(ker(-x))
%
%
%
%   Chenzhe
%   Jun, 2016
%


fprintf('\nCalculating Covariance Matrices......\n');
tic;

% this is to overcome the problem when filtersize is adjusted for extended
% image boundary.
filtersize = size(obj.FilterBank2D(1).ffilter, 1);
if mod(filtersize, N) ~= 0      
    N = filtersize;
end

% if the frames needs to be blurred first
if nargin < 4
    fr = obj.getFrames(N);
else
    fr = obj.getFrames_blur(N, fker);
end

% This function only works for TPCTF. The bands are conjugate pairs. Only
% compute on in a pair to save computational time.
if isempty(obj.pairmap)
    pairmap = obj.getpairmap;
else
    pairmap = obj.pairmap;
end


tmpr = zeros(N^2, blocksize^2);
tmpi = tmpr;

nL = obj.nlevel;
Cwr = cell(1, nL);
Cwi = cell(1, nL);


nb = size(pairmap, 1);  % only half of the all bands, both bands have same covariance matrix
for j = 1:nL
    Cwr{j} = cell(1, 2*nb);
    Cwi{j} = cell(1, 2*nb);
    dist = 2^j;     % shift distance
%     dist = 1;   % for undecimated
    for ib = 1:nb
        
        ib_ind1 = pairmap(ib, 1);   % band index1
        ib_ind2 = pairmap(ib, 2);   % band index2
        % shift in both direction
        count = 1;
        for d1 = 0:blocksize-1
            for d2 = 0:blocksize-1
                tmp = circshift2d(fr{j}{ib_ind1}, d1*dist, d2*dist); % shift to right
                tmp1 = real(tmp);
                tmp2 = imag(tmp);
                tmpr(:, count) = tmp1(:);
                tmpi(:, count) = tmp2(:);
                
                count = count+1;
            end
        end
        
        Cwr{j}{ib_ind1} = tmpr' * tmpr;
        Cwi{j}{ib_ind1} = tmpi' * tmpi;
        
        % the conjugate band has the same covariance matrix
        Cwr{j}{ib_ind2} = Cwr{j}{ib_ind1};
        Cwi{j}{ib_ind2} = Cwi{j}{ib_ind1};
        

    end
end

time_count = toc;
fprintf('Finished CalCovMatrix in %f sec!\n', time_count);


end




