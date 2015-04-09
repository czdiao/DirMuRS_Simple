function [W]= normcoef(W,L,nor)


num_hipass=length(W{1}{1}{1});
for scale = 1:L
    for part = 1:2
        for dir = 1:2
            for dir1 = 1:num_hipass
                W{scale}{part}{dir}{dir1} = W{scale}{part}{dir}{dir1}/nor{scale}{part}{dir}{dir1};
            end
        end
    end
end
end