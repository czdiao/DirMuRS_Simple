clear;

imgName = 'Barbara512.png';
x = double(imread(imgName));

patchsize = 16;
[M, N] = size(x);

Nx = M/patchsize * 2 -1;
Ny = N/patchsize * 2 -1;
allpatch = zeros(patchsize, patchsize, Nx*Ny);

count = 1;
for i = 1:Nx
    for j = 1:Ny
        ii = (i-1)*patchsize/2+1;
        jj = (j-1)*patchsize/2+1;
        allpatch(:,:,count) = x(ii:ii+patchsize-1, jj:jj+patchsize-1);
        count = count + 1;
    end
end

allpatchfreq = zeros(size(allpatch));
Npatch = size(allpatch, 3);

for i = 1:Npatch
    tmp = log(abs(fft2(allpatch(:,:,i))));
    tmp(1,1) = min(tmp(:));
    allpatchfreq(:,:,i) = fftshift(tmp);
end









