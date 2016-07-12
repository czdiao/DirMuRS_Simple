function  fr  = getFrames( obj, N )
%GETFRAMES Generate Frames of each scale/band. This could be used to:
%calculate the frame norm, calculate covariance matrix, plot DAS.
%
%   The output is scaled as decimated transform.
%
%   Although the result is for decimated transform, the code is implemented
%   using undecimated transform. By using undecimated transform, we only
%   need to use forward decomposition of delta signal once, rather than
%   using multiple reconstruction operation. So it would be much faster.
%
%Input:
%   N:
%       Size of the output frames.
%Output:
%   fr{ilevel}{iband}:
%       Representing frames of all levels, bands.
%
%   Chenzhe Diao
%   Jun, 2016
%

nL = obj.nlevel;
fr = cell(1, nL);
rate = obj.FilterBank2D(1).rate;
% rate = 1;   % for undecimated

x = zeros(N);
x(1,1) = 1;

w = obj.decomposition_undecimated(x);
for j = 1:nL
    nband = length(w{j});
    fr{j} = cell(1, nband);
    for ib = 1:nband
        % conjugate flip
        fr{j}{ib} = w{j}{ib}(end:(-1):1, end:(-1):1);
        fr{j}{ib} = conj(fr{j}{ib}) * sqrt(rate*rate)^j;    % scaled to be the same as decimated transform
    end
end


end

