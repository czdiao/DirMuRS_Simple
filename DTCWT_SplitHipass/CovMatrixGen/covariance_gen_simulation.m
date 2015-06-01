function [] = covariance_gen_simulation()
%% Generate Covariance Matrix, by the method of Monte Carlo

%%
sigma = 1;
nLevel = 5;

block = [3, 3];
block_size = block(1)*block(2);


N = 1000; % Repeat times
W = cell(1,N);

[FS_filter2d, filter2d] = DualTreeFilter2d;

for i = 1:N
    n = sigma*randn([512,512]);
    W{i} = DualTree2d( n, nLevel, FS_filter2d, filter2d);
    if mod(i,100)==0
        fprintf('%d times\n', i);
    end
end

%%

nHipass = length(W{1}{1}{1}{1});


Cw = cell(1,nLevel);
for j = 1:nLevel
    Cw{j} = cell(1,2);
    for d1 = 1:2
        Cw{j}{d1} = cell(1,2);
        for d2 = 1:2
            Cw{j}{d1}{d2} = cell(1,nHipass);
            for k = 1:nHipass
                Cw{j}{d1}{d2}{k} = zeros(block_size,block_size);
                for row_count = 1:block_size
                    [i1, j1] = ij_index(row_count, block);
                    for col_count = row_count:block_size
                        [i2,j2] = ij_index(col_count, block);
                        for irepeat = 1:N
                            tmp = W{irepeat}{j}{d1}{d2}{k}(i1,j1)*W{irepeat}{j}{d1}{d2}{k}(i2,j2);
                            Cw{j}{d1}{d2}{k}(row_count, col_count) = Cw{j}{d1}{d2}{k}(row_count, col_count) + tmp;
                        end
                        Cw{j}{d1}{d2}{k}(row_count, col_count) = Cw{j}{d1}{d2}{k}(row_count, col_count)/N;
                        Cw{j}{d1}{d2}{k}(col_count, row_count) = Cw{j}{d1}{d2}{k}(row_count, col_count);
                    end
                end
            end
        end
    end
end



save Cw_DT_MC Cw

end












