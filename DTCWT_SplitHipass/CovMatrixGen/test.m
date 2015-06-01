N = 100;

tmp = cell(1,N);

for k = 1:N
    tmp{k} = covariance_gen_simulation(50, 5, 512);
    fprintf('times = %d\n', k);
end

block_size = 9;
NumHipass = length(tmp{1}{1}{1}{1});
Cw = cell(1, 5);

for j = 1:5
    Cw{j} = cell(1,2);
    for d1 = 1:2
        Cw{j}{d1} = cell(1,2);
        for d2 = 1:2
            Cw{j}{d1}{d2} = cell(1,NumHipass);
            for nhigh = 1:NumHipass
                Cw{j}{d1}{d2}{nhigh} = zeros(block_size,block_size);
                for k = 1:N
                    Cw{j}{d1}{d2}{nhigh} = Cw{j}{d1}{d2}{nhigh} + tmp{k}{j}{d1}{d2}{nhigh}/N;
                end
            end
        end
    end
end

save Cw_MC Cw