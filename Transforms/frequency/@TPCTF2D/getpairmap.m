function [ pairmap ] = getpairmap( obj )
%GETPAIRMAP For TPCTF, find pairs of conjugate bands from freqfilter2d.index 
%information.
%
%
%   Chenzhe Diao
%   Jun, 2016
%

fbhipass = obj.FilterBank2D(2:end);

num = length(fbhipass);
ind = 1:num;

pairmap = zeros(num/2, 2);

count = 1;
while ~isempty(ind)
    for i = 2:length(ind)
        if ~any(fbhipass(1).index + fbhipass(i).index)
            pairmap(count, 1) = ind(1);
            pairmap(count, 2) = ind(i);
            ind(i) = [];
            ind(1) = [];
            fbhipass(i) = [];
            fbhipass(1) = [];
            break;
        end
    end
    count = count+1;
end




end

