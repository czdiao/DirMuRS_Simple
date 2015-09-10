clear;

load frame_dt.mat

nlevel = 5;

for j = 1:nlevel-1
    for d1 = 1:2
        for d2 = 1:2
            num_hipass = length(frame{j}{d1}{d2});
            for nband = 1:num_hipass
                
            end
        end
    end
end
