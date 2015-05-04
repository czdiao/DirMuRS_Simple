function [w1] = bishrink_c(y1,y2,T,c)
% Bivariate Shrinkage Function
% Usage :
%      [w1] = bishrink(y1,y2,T)
% INPUT :
%      y1 - a noisy coefficient value
%      y2 - the corresponding parent value
%      T  - threshold value
% OUTPUT :
%      w1 - the denoised coefficient
c=0;
thr = T.*sqrt(1+c)./sqrt(abs(y1).^2+c*abs(y2).^2);
thr = 1-thr;
thr = thr.*(thr > 0);
w1  = y1.*thr;
