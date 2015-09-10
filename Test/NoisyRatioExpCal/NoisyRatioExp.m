% sigma_range = 5:10:95;
% % crange = -10:0.5:10;
% crange = -10:2:10;
% cprange = -2:2:2;
% 
% E = cell(1,length(sigma_range));
% for i = 1:length(sigma_range)
%     E{i} = zeros(length(crange), length(cprange));
% end
% 
% % parfor k = 1:length(sigma_range)
% for k = 1
%     sigma = sigma_range(k);
%     
%     for i = 1:length(crange)
%         c = crange(i);
%         
%         for j = 1:length(cprange)
%             cp = cprange(j);
%             
%             bound = 5*sigma;
%             f = fun_noisypdf(c, cp, sigma);
%             E{k}(i,j) = integral2(f, -bound, bound, -bound, bound);
%             
%         end
%         if mod(i,10)==0
%             fprintf('i = %d\n', i);
%         end
%     end
%     
% end

% sigma = 100; bound = 500;
% c = 10; cp = 10;
% f = fun_noisypdf(c, cp, sigma);
% E = integral2(f, -bound, bound, -bound, bound)



%%

load('NoisySigmaExpCell.mat', 'E');

c = -10:0.5:10;
cp = -10:0.5:10;
[X, Y] = meshgrid(c, cp);

figure; hold on
colormap([1, 0, 0; 0, 1, 0; 0, 0, 1]);

surf(X, Y, E{2}, ones(41));

surf(X, Y, E{4}, ones(41)+1);

surf(X, Y, E{6}, ones(41)+2);


ylabel('c', 'FontSize', 22);
xlabel('c_p', 'FontSize', 22);
zlabel('E_\sigma (c, c_p)', 'FontSize', 22);
legend('\sigma = 15','\sigma = 35','\sigma = 55')
grid on;
view(3)