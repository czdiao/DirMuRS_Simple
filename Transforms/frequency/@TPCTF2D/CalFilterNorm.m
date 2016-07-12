function [ nor ] = CalFilterNorm( obj, signal_size )
%CALFILTERNORM filter norm calculation could be based on getFrames(), 
% which is faster.
%
%   Need to be tested again.
%
%   Chenzhe
%   Jun, 2016
%

if nargin == 1
    signal_size = [512, 512];
end

nL = obj.level_norm;
obj.nlevel = nL;
fr = obj.getFrames(signal_size(1));

nor = cell(1, nL);
for j = 1:nL
    nb = length(fr{j});
    nor{j} = cell(nb);
    for ib = 1:nb
        nor{j}{ib} = norm(abs(fr{j}{ib}), 'fro');
    end
end



end

