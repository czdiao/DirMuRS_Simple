function [] = covariance_gen_exact()
%% Generate Covariance Matrix, by the method of Monte Carlo

%%
nLevel = 5;

block = [5, 5];
block_size = block(1)*block(2);



[FS_filter2d, filter2d] = DualTreeFilter2d;

n = zeros(512,512);
W = Framelet2d( n, nLevel, FS_filter2d{1}{1}, filter2d{1}{1});

%%

nHipass = length(W{1});

x11 = cell(1, block_size);
x12 = x11; x21 = x11; x22 = x11;

Cw = cell(1,nLevel);
for j = 1:nLevel  %nLevel
    
    Cw{j} = cell(1,2);
    for d1 = 1:2     %2
        Cw{j}{d1} = cell(1,2);
        for d2 = 1:2    %2
            Cw{j}{d1}{d2} = cell(1,nHipass);
            for k = 1:nHipass %nHipass
                Cw{j}{d1}{d2}{k} = zeros(block_size,block_size);
            end
        end
    end
    i_center = floor(size(W{j}{1},1)/2)-1;
    j_center = floor(size(W{j}{1},2)/2)-1;
    for k = 1:nHipass %nHipass
        for count = 1:block_size
            [i1, j1] = ij_index(count, block);
            
            W{j}{k}(i1 + i_center, j1 + j_center) = 1/2;
            x11{count} = iFramelet2d(W,nLevel, FS_filter2d{1}{1}, filter2d{1}{1});
            x12{count} = iFramelet2d(W,nLevel, FS_filter2d{1}{2}, filter2d{1}{2});
            x21{count} = iFramelet2d(W,nLevel, FS_filter2d{2}{1}, filter2d{2}{1});
            x22{count} = iFramelet2d(W,nLevel, FS_filter2d{2}{2}, filter2d{2}{2});
            [x11{count}, x22{count}] = pm(x11{count}, x22{count});
            [x12{count}, x21{count}] = pm(x12{count}, x21{count});

            W{j}{k}(i1 + i_center,j1 + j_center) = 0;
        end
        
        for row_count = 1:block_size
            for col_count = row_count:block_size
                Cw{j}{1}{1}{k}(row_count, col_count) = sum(sum(x11{row_count}.*x11{col_count}));
                Cw{j}{1}{2}{k}(row_count, col_count) = sum(sum(x12{row_count}.*x12{col_count}));
                Cw{j}{2}{1}{k}(row_count, col_count) = sum(sum(x21{row_count}.*x21{col_count}));
                Cw{j}{2}{2}{k}(row_count, col_count) = sum(sum(x22{row_count}.*x22{col_count}));
                
                for d1 = 1:2
                    for d2 = 1:2
                        Cw{j}{d1}{d2}{k}(col_count, row_count) = Cw{j}{d1}{d2}{k}(row_count, col_count);
                    end
                end
                
            end
        end

    end

    fprintf('Finished Level %d\n', j);
end

save Cw_DT_exact_5 Cw

end














