function [ wt ] = convert_struct( W )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

wt.type = 'cplxdt';
wt.level = length(W)-1;
wt.filters = [];

L = wt.level;
wt.cfs = cell(1, L+1);

nband = 3;
for i = 1:L
    [M, N] = size(W{i}{1}{1}{1});
    wt.cfs{i} = zeros(M, N, nband, 2, 2);
    for d = 1:nband
        for k = 1:2
            for m = 1:2
                
                wt.cfs{i}(:,:,d,k,m) = W{i}{m}{k}{d};
            end
        end
    end
end

[M, N] = size(W{L+1}{1}{1});
wt.cfs{L+1} = zeros(M, N, 2, 2);
for k = 1:2
    for m = 1:2
        wt.cfs{L+1}(:,:,k,m) = W{L+1}{k}{m};
    end
end

wt.sizes = [];

end

