function [ fb2d ] = Angular_FilterBank_freq2D_bump( Rl, K, N )
%ANGULAR_FILTERBANK_FREQ2D_BUMP 2D Frequency filter bank in angular partition.
%
%   Called by GenAngular_FB_freq2D_disk() and GenAngular_FB_freq2D_gaussian()
%
%Input:
%   Rl:
%       Array for partition point of R. Length = L for L*K hipass
%   epsR:
%       Smoothing radius for Rl. array of length L+1, the last one for side
%   K:
%       Number of angluar partition.
%   epsTheta:
%       Smoothing radius for angle partition. Should be a double number.
%   N:  (Optional)
%       Number of discrete frequency in cartesian coords.
%
%
%   Note:
%       This function generates filter bank only of one level. And create a
%       filter only between 2 Rl points bump. Should call the new no bump
%       version.
%
%
%   Chenzhe
%   Jun, 2016
%

if nargin == 2
    N = 1024;
end

L = length(Rl);

% generate epsR, epsTheta
space = Rl(2:end) - Rl(1:end-1);
space = [Rl(1), space, pi-Rl(end)];
epsR(L+1) = space(end)/2.1;
for i = L:(-1):1
    epsR(i) = min((space(i+1) - epsR(i+1))/1.1, space(i)/2.1);
    if epsR(i)<=0
        error('Smoothing radius for R is not positive!');
    end
end
epsTheta = pi/K/2.05;



f = 0:1/N:(N-1)/N;
f = f*2*pi;
f = f - 2*pi*(f>pi+eps);    % shift into [-pi, pi]

[X, Y] = meshgrid(f);
[Theta, Rho] = cart2pol(X, Y);  % into polar coordinate, Theta \in [-pi, pi]
Theta = Theta + pi*(Theta<0);     % Theta \in [0, pi],  So the filters are real in time domain.

% lowpass
tmp = fchi(Rho, -2, Rl(1), 0.001, epsR(1));
lowpass = freqfilter2d;
lowpass.ffilter = tmp;
lowpass.rate = 1;   % undecimated



% hipass: except the finest level, initialization
L = length(Rl);
hipass((L-1)*K) = freqfilter2d;
dtheta = pi/K;
count = 1;

% initialization for finest(first) level: hipass_out
hipass_out(K) = freqfilter2d;
% For each grid point, find its shifted coordinates
X_ext = X;
X_ext(X>=0) = X_ext(X>=0)-2*pi;
X_ext(X<0) = X_ext(X<0) + 2*pi;
Y_ext = Y;
Y_ext(Y>=0) = Y_ext(Y>=0)-2*pi;
Y_ext(Y<0) = Y_ext(Y<0) + 2*pi;

Theta_ext = cell(1,3);
Rho_ext = cell(1,3);
[Theta_ext{1}, Rho_ext{1}] = cart2pol(X_ext, Y);  % into polar coordinate, Theta \in [-pi, pi]
Theta_ext{1} = Theta_ext{1} + pi*(Theta_ext{1}<0);     % Theta \in [0, pi],  So the filters are real in time domain.
[Theta_ext{2}, Rho_ext{2}] = cart2pol(X, Y_ext);  % into polar coordinate, Theta \in [-pi, pi]
Theta_ext{2} = Theta_ext{2} + pi*(Theta_ext{2}<0);     % Theta \in [0, pi],  So the filters are real in time domain.
[Theta_ext{3}, Rho_ext{3}] = cart2pol(X_ext, Y_ext);  % into polar coordinate, Theta \in [-pi, pi]
Theta_ext{3} = Theta_ext{3} + pi*(Theta_ext{3}<0);     % Theta \in [0, pi],  So the filters are real in time domain.

tmpX = fchi(X, -pi, pi, epsR(L+1), epsR(L+1));
tmpY = fchi(Y, -pi, pi, epsR(L+1), epsR(L+1));

tmpX_ext = fchi(X_ext, -pi, pi, epsR(L+1), epsR(L+1));
tmpY_ext = fchi(Y_ext, -pi, pi, epsR(L+1), epsR(L+1));

tmpXY = tmpX.*tmpY;
tmpXY_ext{1} = tmpX_ext.*tmpY;
tmpXY_ext{2} = tmpX.*tmpY_ext;
tmpXY_ext{3} = tmpX_ext.*tmpY_ext;


for k = 1:K
    tmpTheta1 = fchi(Theta, dtheta*(k-0.5), dtheta*(k+0.5), epsTheta, epsTheta);
    tmpTheta2 = fchi(Theta, dtheta*(k-0.5)-pi, dtheta*(k+0.5)-pi, epsTheta, epsTheta);
    tmpTheta = tmpTheta1 + tmpTheta2;
    
    % except for the finest level
    for l = 2:L
        tmpR = fchi(Rho, Rl(l-1), Rl(l), epsR(l-1), epsR(l));
        tmp = tmpR.*tmpTheta;
        hipass(count).ffilter = tmp;
        hipass(count).rate = 1;
        
        count = count + 1;
    end
    
    % finest(first) level
    tmpR = fchi(Rho, Rl(L), 20, epsR(L), 0.01);
    tmp = tmpR.*tmpTheta;   % not smooth on the square boundary
    tmp_smooth = tmp.*tmpXY;
    
    % extended
    tmpTheta_ext = cell(1,3);
    for i = 1:3
        tmpTheta1_ext = fchi(Theta_ext{i}, dtheta*(k-0.5), dtheta*(k+0.5), epsTheta, epsTheta);
        tmpTheta2_ext = fchi(Theta_ext{i}, dtheta*(k-0.5)-pi, dtheta*(k+0.5)-pi, epsTheta, epsTheta);
        tmpTheta_ext{i} = tmpTheta1_ext + tmpTheta2_ext;
        tmp_smooth_ext = tmpTheta_ext{i}.*tmpXY_ext{i};
        tmp_smooth = sqrt(tmp_smooth.^2 + tmp_smooth_ext.^2);
    end
        
    hipass_out(k).ffilter = tmp_smooth;
    hipass_out(k).rate = 1;
    
end

% rearange hipass
order = 1:K*(L-1);
order = reshape(order, (L-1), K);
order = order';
order = order(:)';
hipass = hipass(order);


fb2d = [lowpass, hipass, hipass_out];


end

