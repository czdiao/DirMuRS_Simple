clear;

[FS_filter2d, filter2d] = DualTreeFilter2d;

nlevel = 5;

x = zeros(256,256);

w = DualTree2d(x, nlevel, FS_filter2d, filter2d);

frame = cell(1, nlevel);

for j = 1:nlevel
    frame{j} = cell(1,2);
    for d1 = 1:2
        frame{j}{d1} = cell(1,2);
        for d2 = 1:2
            num_hipass = length(w{j}{d1}{d2});
            frame{j}{d1}{d2} = cell(1,num_hipass);
            for nband = 1:num_hipass
                w{j}{d1}{d2}{nband}(1, 1) = 1;
                frame{j}{d1}{d2}{nband} = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
                w{j}{d1}{d2}{nband}(1, 1) = 0;

            end
        end
    end
    fprintf('finished j = %d\n', j);
end

save frame_dt frame


