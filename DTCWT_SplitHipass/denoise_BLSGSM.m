function y = denoise_BLSGSM( x,J, sigmaN, FS_filter2d, filter2d )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Extend and DT-CWT
L = length(x); % length of the original image.
buffer_size = L/2;
x = symext(x,buffer_size);

W = DualTree2d(x, J, FS_filter2d, filter2d);

%% GSM
logzmin = -20.5; logzmax = 3.5; Nz = 13;
logz_list = linspace(logzmin,logzmax,Nz);
params.block = [3,3];
params.optim = 1;
params.parent = 0;
params.covariance = 1;
load Cw_DT_exact_3;
% load Cw_MC_5;


num_hipass = length(W{1}{1}{1});
for j = 1:J
    for d1 = 1:2
        for d2 = 1:2
            for k = 1:num_hipass
                W{j}{d1}{d2}{k} = BLSGSM5(W{j}{d1}{d2}{k},(sigmaN^2)*Cw{j}{d1}{d2}{k},logz_list,params);
            end
        end
    end
end



%% Inverse DT-CWT
y = iDualTree2d(W, J, FS_filter2d, filter2d);
ind = buffer_size+1 : buffer_size+L;
y = y(ind,ind);


end

