function [ w ] = DualTree2d( x, J, FS_filter2d, filter2d)
%DUALTREE2D Summary of this function goes here
%   Detailed explanation goes here

%[FS_filter2d, filter2d] = DualTreeFilter2d;

w = cell(1, J+1);

x = x/2;    % Debug, to make the same normalization as Selesnick

num_hipass = length(filter2d{1}{1})-1;  % t

for rowtree = 1:2
    for coltree = 1:2
        
        % First Stage
        LL = analysis2d(x, FS_filter2d{rowtree}{coltree}(1));   % lowpass
        for i = 1:num_hipass     % Hipass
            w{1}{rowtree}{coltree}{i} = analysis2d(x, FS_filter2d{rowtree}{coltree}(i+1));
        end
        % Later Stages
        for j = 2:J
            for i = 1:num_hipass     % Hipass
                w{j}{rowtree}{coltree}{i} = analysis2d(LL, filter2d{rowtree}{coltree}(i+1));
            end
            LL = analysis2d(LL, filter2d{rowtree}{coltree}(1)); % lowpass
        end
        w{J+1}{rowtree}{coltree} = LL;
        
    end
end


for j = 1:J
    for m = 1:num_hipass
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end


end

