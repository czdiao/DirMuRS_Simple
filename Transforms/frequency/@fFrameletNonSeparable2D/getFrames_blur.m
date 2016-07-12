function [ fr_blurred ] = getFrames_blur( obj, N, fker )
%GETFRAMES_BLUR Generate Frames of each scale/band. This could be used to:
%calculate the frame norm, calculate covariance matrix, plot DAS.
%   The output is scaled as decimated transform.
%
%   This function is similar to getFrames(). However, if the signal is
%   firstly blurred by kernel ker(x), the effect would be same as the
%   frames blurred by conjugate flip of ker:
%       ker_star = conj(ker(-x))
%       fr_blurred = fr \convolve ker_star
%
%   This could be used in CalCovMatrix to calculate blurred noise
%   covariance matrix (used in GSM model). Or visualize the effect of
%   blurred kernel to the wavelet frames, etc.
%
%
%   Chenzhe Diao
%   Jun, 2016
%

% ker_star = conj(ker(end:(-1):1, end:(-1):1));
ker_star = conj(fker);     % ker in freq domain

fr  = getFrames( obj, N );  % unblurred frames
fr_blurred = fr;
nL = obj.nlevel;

for iL = 1:nL
    nB = length(fr{iL});
    for iB = 1:nB
%         fr_blurred{iL}{iB} = imfilter(fr{iL}{iB},ker_star,'circular');
        fr_blurred{iL}{iB} = ifft2(fft2(fr{iL}{iB}).*ker_star);   % freq domain 

    end
end




end

