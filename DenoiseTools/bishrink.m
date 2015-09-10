function [w1] = bishrink(y1,y2,T)
% Bivariate Shrinkage Function
% Usage :
%      [w1] = bishrink(y1,y2,T)
% INPUT :
%      y1 - a noisy coefficient value
%      y2 - the corresponding parent value
%      T  - threshold value
% OUTPUT :
%      w1 - the denoised coefficient


R  = sqrt(abs(y1).^2 + abs(y2).^2);
R = R - T;
R  = R .* (R > 0);
w1 = y1 .* R./(R+T); 


%% Change to different Thresholding
% R  = sqrt(abs(y1).^2 + abs(y2).^2);
% R = max(R, eps);
% Thresh = sqrt(3)*T.*abs(y1)./R;
% w1 = y1.*(abs(y1) > Thresh);  % Hard Thresholding

%Changed
% C = sqrt(3)*0.3;
% C2 = 0.9;
% Thresh = T .* exp(C*abs(y1)./R)*C2;
% w1 = quantization(y1, Thresh, 0, 0);


end