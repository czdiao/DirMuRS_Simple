function [ fb2d ] = Angular_FilterBank_freq2D( Rl, Lv, K, N )
%ANGULAR_FILTERBANK_FREQ2D 2D Frequency filter bank in angular partition.
%
%   Called by GenAngular_FB_freq2D_disk() and GenAngular_FB_freq2D_gaussian()
%
%Input:
%   Rl:
%       Array for partition point of R. Length = L for L*K hipass
%   Lv:
%       Level of partition.
%   K:
%       Number of angluar partition.
%   N:  (Optional)
%       Number of discrete frequency in cartesian coords.
%
%
%   Note:
%       This function generates filter bank only of multi-level. Create
%       filters at both frequency bumps and pits.
%
%
%   Chenzhe
%   Jun, 2016
%

if nargin == 3
    N = 1024;
end

L = length(Rl);

%% 1. initialize polar/Cartesian coords: X, Y, Theta, Rho
f = 0:1/N:(N-1)/N;
f = f*2*pi;
f = f - 2*pi*(f>pi+eps);    % shift into [-pi, pi]

[X, Y] = meshgrid(f);
[Theta, Rho] = cart2pol(X, Y);  % into polar coordinate, Theta \in [-pi, pi]
Theta = Theta + pi*(Theta<0);     % Theta \in [0, pi],  So the filters are real in time domain.


%% 2. compute the angular partition: tmpTheta{K}
epsTheta = pi/K/2.05;
dtheta = pi/K;
tmpTheta = cell(1, K);
for k = 1:K
    tmpTheta1 = fchi(Theta, dtheta*(k-0.5), dtheta*(k+0.5), epsTheta, epsTheta);
    tmpTheta2 = fchi(Theta, dtheta*(k-0.5)-pi, dtheta*(k+0.5)-pi, epsTheta, epsTheta);
    tmpTheta{k} = tmpTheta1 + tmpTheta2;
end


%% 3. generate hipass for outer square: hipass_out(K)
epsR = (pi-Rl(L))/3.1;
epsL = epsR;
cL = Rl(L) + epsR*1.05; % inner radius cut point

hipass_out = GenOutRadiusFBLv1(X, Y, Rho, tmpTheta, epsR, epsL, cL);

%% 4. Generate first level inner circle filters, construct all 1st level filters: fb2d
[lowpass, hipass_ring] = GenRadiusFB(Rho, Rl, cL, epsL);
len = length(hipass_ring);

hipass(len*K) = freqfilter2d;
count = 1;
for l = 1:len
    for k = 1:K
        hipass(count).ffilter = hipass_ring(l).ffilter.*tmpTheta{k};
        hipass(count).rate = 1;
        count = count + 1;
    end
end

fb2d = [lowpass, hipass, hipass_out];   % The first level FB construction finished
hipass(:) = [];    % clear memory for hipass

%% 5. loop for inner level, construct filter bank.
r = Rl(1)/pi;   % similar to decimation rate, shrinkage rate in freq domain of next level
hipass(len*K) = freqfilter2d;   % initialize again
for ilevel = 2:Lv
    lowpass = fb2d(1);
    endpoint = Rl(1);
    Rl = Rl*r;
    
    epsL = (endpoint-Rl(L))/3.1;
    cL = Rl(L) + epsL*1.05; % inner radius cut point
    hipass1_ring = GenOutRadiusFB(Rho, epsL, cL);
    
    [lowpass_new, hipass_ring] = GenRadiusFB(Rho, Rl, cL, epsL);
    hipass_ring = [hipass_ring, hipass1_ring];
    len = length(hipass_ring);
    for j = 1:len
        hipass_ring(j).ffilter = hipass_ring(j).ffilter.*lowpass.ffilter;
    end
    
    count = 1;
    for l = 1:len
        for k = 1:K
            hipass(count).ffilter = hipass_ring(l).ffilter.*tmpTheta{k};
            hipass(count).rate = 1;
            count = count + 1;
        end
    end
    
    fb2d(1) = lowpass_new;  % change to new lowpass
    fb2d = [fb2d, hipass];

end



end


function hipass_out = GenOutRadiusFBLv1(X, Y, Rho, tmpTheta, epsR, epsL, cL)
%%Input:
%   [X, Y]:
%       The Cartesian coords of the points in [-pi, pi]. Both X and Y
%       are matrices of the same size.
%   Rho:
%       Polar coords of the points. Only need Rho here for Radius partition
%   tmpTheta{K}:
%       Computed partition for angles. Each tmpTheta{k} is a matrix.
%   epsR:
%       Smoothing radius for outter square boundary.
%   epsL:
%       Smoothing radius for inner circular boundary.
%   cL:
%       Inner radius bump cut center
%
%Output:
%   hipass_out(K)
%


% Compute X_ext, Y_ext, Theta_ext{3} for coords in extended domain.
X_ext = X;
X_ext(X>=0) = X_ext(X>=0)-2*pi;
X_ext(X<0) = X_ext(X<0) + 2*pi;
Y_ext = Y;
Y_ext(Y>=0) = Y_ext(Y>=0)-2*pi;
Y_ext(Y<0) = Y_ext(Y<0) + 2*pi;

Theta_ext = cell(1,3);
[Theta_ext{1}, ~] = cart2pol(X_ext, Y);  % into polar coordinate, Theta \in [-pi, pi]
Theta_ext{1} = Theta_ext{1} + pi*(Theta_ext{1}<0);     % Theta \in [0, pi],  So the filters are real in time domain.
[Theta_ext{2}, ~] = cart2pol(X, Y_ext);  % into polar coordinate, Theta \in [-pi, pi]
Theta_ext{2} = Theta_ext{2} + pi*(Theta_ext{2}<0);     % Theta \in [0, pi],  So the filters are real in time domain.
[Theta_ext{3}, ~] = cart2pol(X_ext, Y_ext);  % into polar coordinate, Theta \in [-pi, pi]
Theta_ext{3} = Theta_ext{3} + pi*(Theta_ext{3}<0);     % Theta \in [0, pi],  So the filters are real in time domain.



% compute bump at square boundary
tmpX = fchi(X, -pi, pi, epsR, epsR);
tmpY = fchi(Y, -pi, pi, epsR, epsR);

tmpX_ext = fchi(X_ext, -pi, pi, epsR, epsR);
tmpY_ext = fchi(Y_ext, -pi, pi, epsR, epsR);

tmpXY = tmpX.*tmpY;     % inner cartesian bump
tmpXY_ext{1} = tmpX_ext.*tmpY;  % cartesian bump for ext1
tmpXY_ext{2} = tmpX.*tmpY_ext;  % cartesian bump for ext2
tmpXY_ext{3} = tmpX_ext.*tmpY_ext;  % cartesian bump for ext3

K = length(tmpTheta);
hipass_out(K) = freqfilter2d; % initialization for finest(first) level: hipass_out

epsTheta = pi/K/2.05;
dtheta = pi/K;

for k = 1:K
    % finest(first) level
    tmpR = fchi(Rho, cL, 20, epsL, 0.01); % cut for inner circle
    tmp = tmpR.*tmpTheta{k};   % not smooth on the square boundary
    tmp_smooth = tmp.*tmpXY;
    
    % extended
    for i = 1:3
        tmpTheta1_ext = fchi(Theta_ext{i}, dtheta*(k-0.5), dtheta*(k+0.5), epsTheta, epsTheta);
        tmpTheta2_ext = fchi(Theta_ext{i}, dtheta*(k-0.5)-pi, dtheta*(k+0.5)-pi, epsTheta, epsTheta);
        tmpTheta_ext = tmpTheta1_ext + tmpTheta2_ext;
        tmp_smooth_ext = tmpTheta_ext.*tmpXY_ext{i};
        
        tmp_smooth = sqrt(tmp_smooth.^2 + tmp_smooth_ext.^2);
    end
        
    hipass_out(k).ffilter = tmp_smooth;
    hipass_out(k).rate = 1;
end




end

function hipass_ring = GenOutRadiusFB(Rho, epsL, cL)
tmpR = fchi(Rho, cL, 10, epsL, 0.01);
hipass_ring = freqfilter2d;
hipass_ring.ffilter = tmpR;
end

function [lowpass, hipass_ring] = GenRadiusFB(Rho, Rl, cR, epsR)
%%Generate Radius Filter Bank. The filters here are rings in frequency
% domain. They are not cut in angular direction.
%
%Input:
%   Rho:
%       Polar Coords in frequency domain. Should be an input matrix.
%   Rl:
%       Radius Cutting points. Increasing sequency. length(Rl) = L.
%   cR:
%       The outter most bump outter fchi center position.
%   epsR:
%       The outter most bump outter smoothing radius.
%
%   Note:
%       We need to require:     cR-epsR > Rl(L)
%
%Output:
%   lowpass:
%       The generated lowpass. Should be a radius bump in frequency domain.
%   hipass_ring:
%       The generated hipass. Should be rings in frequency domain.
%       length(hipass_ring) = 2*L-1
%
%

L = length(Rl);

hipass_ring(2*L-1) = freqfilter2d;
cL = cR;
epsL = epsR;
for i = (L-1):(-1):1
    epsR = epsL;
    cR = cL;
    epsL = (Rl(i+1) - Rl(i))/4.1;
    cL = Rl(i+1) - epsL*1.025;
    tmpR = fchi(Rho, cL, cR, epsL, epsR);
    hipass_ring(2*i+1).ffilter = tmpR;
    
    epsR = epsL;
    cR = cL;
    cL = Rl(i) + epsL*1.025;
    tmpR = fchi(Rho, cL, cR, epsL, epsR);
    hipass_ring(2*i).ffilter = tmpR;
end

epsR = epsL;
cR = cL;
cL = Rl(1) - epsL*1.025;
tmpR = fchi(Rho, cL, cR, epsL, epsR);
hipass_ring(1).ffilter = tmpR;

% lowpass
cR = cL;
epsR = epsL;
tmpR = fchi(Rho, -2, cR, 0.001, epsR);
lowpass = freqfilter2d;
lowpass.ffilter = tmpR;
lowpass.rate = 1;   % undecimated


end




