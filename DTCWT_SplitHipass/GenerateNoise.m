sigmaN = [5, 10, 25, 40, 50, 80, 100];
len = length(sigmaN);

noise512 = cell(1,len);
for i = 1:len
    sigma = sigmaN(i);
    noise512{i} = sigma*randn([512,512]);
    std(noise512{i}(:));
end

save noise512 noise512
