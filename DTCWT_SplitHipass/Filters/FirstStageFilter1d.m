function [ filter ] = FirstStageFilter1d
%FIRSTSTAGEFILTER Dual Tree First Stage Filter by Selesnick
%   Output in standard data structure of 1D filter bank

lo.filter = [-1, 1, 4+sqrt(15), 4+sqrt(15), 1, -1, 4-sqrt(15), 4-sqrt(15)]/16;
lo.start_pt = -3;

% hi.filter = [4-sqrt(15), -4+sqrt(15), -1, -1, 4+sqrt(15), -4-sqrt(15), 1, 1]/16;
% hi.start_pt = -3;

%% Original
hi = CQF(lo);

%% Tried 2-free variables polynomial for w
% s = sqrt(2)*[-0.16199627279092034419363964818451e-34,...
%     0.30751224235353658929917963419799e-33,...
%     -0.80025809012968113651711154711772e-2,...
%     0.44178765084661624265817535247569e-2,...
%     0.11116246707080455717277442535686e0,...
%     -0.13406367959145776308075665508575e0,...
%     -0.18393342641945812772505247960317e0,...
%     0.34295989180634781038678245428838e0,...
%     -0.13594006898600597961503655160284e0,...
%     0.5503701761137536933419966089358e-2,...
%     0.3776458345893056292041714497768e-2,...
%     -0.20917055356245545122179589409675e-2,...
%     -0.37889340588058869133655530532448e-2
% ];
% 
% hi.filter = s(end:-1:1);
% hi.start_pt = -9;

%% Tried 1-free variable polynomial for w, denoise better only for high noise of Barbara and Lena
% s = sqrt(2)*[-0.11683432030120116297589076772848e-33,...
%     0.44194173824159220275052772631553e-1,...
%     0.44194173824159220275052772631534e-1,...
%     -0.34793999451700129155551414765142e0,...
%     0.34793999451700129155551414765144e0,...
%     -0.44194173824159220275052772631549e-1,...
%     -0.44194173824159220275052772631550e-1,...
%     -0.56133960762724706449080334009609e-2,...
%     0.56133960762724706449080334009615e-2];
% hi.filter = s(end:-1:1);
% hi.start_pt = -7;





filter = [lo, hi];

end

