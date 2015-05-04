function [ w ] = Framelet2d( x, J, FS_filter2d, filter2d )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

w = cell(1, J+1);

num_hipass = length(filter2d)-1;

LL = analysis2d(x, FS_filter2d(1));
for i = 1:num_hipass
    w{1}{i} = analysis2d(x, FS_filter2d(i+1));
end
for j = 2:J
    for i = 1:num_hipass
        w{j}{i} = analysis2d(LL, filter2d(i+1));
    end
    LL = analysis2d(LL, filter2d(1));
end
w{J+1} = LL;


end

