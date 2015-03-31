
L = 5;

[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;

num_hipass = length(filter2d{1}{1})-1;

nor = cell(1,L);
lo = cell(1,2);
for dir1 = 1:2
    for dir2 = 1:2
        lo{dir1}{dir2} = sqrt(Filter2SqNorm(FS_filter2d{dir1}{dir2}(1)));
        for i = 1:num_hipass
            nor{1}{dir1}{dir2}{i} = sqrt(Filter2SqNorm(FS_filter2d{dir1}{dir2}(i+1)));
        end
    end
end

for scale = 2:L
    for part = 1:2
        for dir = 1:2
            for dir1 = 1:num_hipass
                nor{scale}{part}{dir}{dir1} = lo{part}{dir} * sqrt(Filter2SqNorm(filter2d{part}{dir}(dir1+1)));
            end
            
            lo{part}{dir} = lo{part}{dir}*sqrt(Filter2SqNorm(FS_filter2d{part}{dir}(1)));
        end
    end
end

save nor_dualtree_filternorm nor
