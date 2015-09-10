%% Denoise Tools
% Denoising functions.

%% Soft Shrinkage
x = -5:0.01:5;
T = 1;
y = soft(x, T);
plot(x,y)
grid on

%% Quantization
figure;
x = -5:0.01:5;
y = quantization(x, 1, 0, 0);
plot(x,y)
set(gca,'YTick', -6:1:6);
grid on