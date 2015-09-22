function [ filter ] = FirstStageFilterShift1d(shift_method)
%FIRSTSTAGEFILTERSHIFT1D Dual Tree First Stage Filter by Selesnick
%   First Stage Filter for Tree 2, lowpass is the shifted version as Tree 1
%   lowpass: a02(.)=a01(.-1)
%
%Input:
%   shift_method:
%       Choose between 'shift', 'flip'. Default is 'flip', as Selesnick's
%       original code.
%
%   This is the same as Zhao and Han's paper

if nargin<1
    shift_method = 'flip';
end

a01 = FirstStageFilter1d;
switch shift_method
    case('flip')
        % Method 1, flip
        lo = a01(1).conjflip;
        lo.start_pt = -4;
    case('shift')
        % Method 2, shift
        lo = a01(1);
        lo.start_pt = -2;
    otherwise
        error('Wrong input!');
end

%% Original
hi = CQF(lo);

%% Tried 2-free variables polynomial for w
% s = sqrt(2)*[-0.28133669355571652106085738938682e-2,...
%     0.15531373999954576904783636235627e-2,...
%     0.27849627551611373171005463879724e-1,...
%     -0.17913163154282647449705500412071e-1,...
%     0.4494833974528514635202082785639e-1,...
%     -0.31259361290085241079025617849729e0,...
%     0.42358996885255469360157905905090e0,...
%     -0.12758447369057075635683046108719e0,...
%     -0.53763849769202112837840660758877e-1,...
%     0.5949825655148975850687652097126e-2,...
%     0.10777567245869445979470008141594e-1,...
%     0.36557011282785480516686014482084e-33,...
%     0
% ];
% hi.filter = s(end:-1:1);
% hi.start_pt = -9;


%% Tried 1-free variable polynomial for w, denoise better only for high noise of Barbara and Lena
% s = sqrt(2)*[0.44194173824159220275052772631551e-1,...
%     0.44194173824159220275052772631544e-1,...
%     -0.34793999451700129155551414765145e0,...
%     0.34793999451700129155551414765144e0,...
%     -0.44194173824159220275052772631557e-1,...
%     -0.44194173824159220275052772631546e-1,...
%     -0.56133960762724706449080334009614e-2,...
%     0.56133960762724706449080334009615e-2,...
%     0];
% 
% hi.filter = s(end:-1:1);
% hi.start_pt = -7;



filter = [lo, hi];

end

