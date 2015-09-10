sigmaN = [5, 10, 30, 50, 80, 100];
len = length(sigmaN);

noise512 = cell(1,len);
for i = 1:len
    sigma = sigmaN(i);
    randn('seed',0);
    noise512{i} = sigma*randn([512,512]);
    std(noise512{i}(:))
end

save noise_thresh noise512
