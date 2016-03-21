function [ fb2d_new ] = FBCombineGroup( Group, fb2d )
%FBCOMBINEGROUP Combine the grouped filter banks
%
%
%   Chenzhe
%   Mar, 2016
%

nGroup = length(Group);
fb2d_new(nGroup) = freqfilter2d;

for i = 1:nGroup
    len = length(Group{i});
    fb2d_new(i) = fb2d(Group{i}(1));
    for j = 2:len
        no = Group{i}(j);
        fb2d_new(i) = fb2d_new(i).add(fb2d(no));
    end
end



end

