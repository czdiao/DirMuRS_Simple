% clear;close all;clc
TEST_ON = 0;

if TEST_ON
    
    load zzp;
    coef = real(coefs{1}{4});
    x = im2col(coef,[5 5],'sliding');
    init = 8;
    [label, model, llh] = emgm(x, init);
    %     [label, model, L] = vbgm(x, init);
    mask = col2im(label,[5 5],size(coef));
    figure, imagesc(coef),colormap(gray),axis image
    figure, imagesc(mask),axis image
    
else
    load data; init = 6;
    % [label, model, llh] = emgm(x, init);
    [label, model, L] = vbgm(x, init);
    % show the result
    spread(x, label)
end