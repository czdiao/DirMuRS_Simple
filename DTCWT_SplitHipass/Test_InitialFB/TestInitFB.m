%% Find the best Initial Filter Bank

clear;


row = 1;

Best_Table = ones(861, 5)*Inf;
% t1, t2:   Best c1, d1, int(bp)

I = sqrt(-1);
for t2 = 1:0.1:1
% for t2 = 1
    for t1 = (-2*t2-2):0.4:1-t2     % 861 total (t1, t2) pair
%     for t1 = 1-t2
        
        [az, uz] = InitialLowpass(t1, t2);
        
        
        count = 0;
        for c1 = -1:0.1:1
%         for c1 = 0.37
%             for d1 = [-0.36:0.001:-0.34, 0.34:0.001:0.36]
            for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2)
                count = count + 1;
            end
        end
        
        tmp_list = ones(count, 3)*inf;
        count = 1;
        for c1 = -1:0.1:1
%         for c1 = 0.37
%             for d1 = [-0.36:0.001:-0.34, 0.34:0.001:0.36]
            for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2)
                [b1, b2] = InitialHighpass(uz, c1, d1);
                bp = b1 + I.* b2;
                bpsq = bp.sq;
                obj = real(bpsq.IntNegReal);
                obj2 = real(bpsq.IntPosReal);
                tmp_list(count, 1) = c1;
                tmp_list(count, 2) = d1;
                tmp_list(count, 3) = obj/obj2;
                count = count + 1;
            end
        end
        
        tmpobj = tmp_list(:,3);
        [bestbp, ind] = min(tmpobj);
        bestc1 = tmp_list(ind, 1);
        bestd1 = tmp_list(ind, 2);
        
        Best_Table(row, 1) = t1;
        Best_Table(row, 2) = t2;
        Best_Table(row, 3) = bestc1;
        Best_Table(row, 4) = bestd1;
        Best_Table(row, 5) = bestbp;
        
        row = row +1;
        
        if mod(row, 10) == 0
            fprintf('\n row = %d, t1=%f, t2=%f', row, t1, t2);
        end
    end
end

fprintf('\n Finished Part 1\n');

%%

t2 = 3;

t1 = -2*t2-2;
% c1 = 0.37;
% d1 = 0.35;

% t1 = -2*t2 + 2*sqrt(t2);
% t1 = 1-t2;
c1 = 0.37;
d1 = 0.35;

[az, uz] = InitialLowpass(t1, t2);
[b1, b2] = InitialHighpass(uz, c1, d1);

I = sqrt(-1);
bp = b1 + I.* b2;

bp2 = bp.sq;
hold on; bp2.fplot
% 
% % figure;
% az2 = az.sq;
% az2.fplot

% legend('neg','ratio');

%% Part 2
% 
% row = 1;
% 
% Best_Table2 = ones(975, 5)*Inf;
% % t1, t2:   Best c1, d1, int(bp)
% 
% I = sqrt(-1);
% for t2 = 1.1:0.1:3
%     for t1 = (-2*t2-2):0.1:(-2*t2+ 2*sqrt(t2))    % 861 total (t1, t2) pair
%         
%         [az, uz] = InitialLowpass(t1, t2);
%         
%         
%         count = 0;
%         for c1 = -1:0.1:1
%             for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2)
%                 count = count + 1;
%             end
%         end
%         
%         tmp_list = ones(count, 3)*inf;
%         count = 1;
%         for c1 = -1:0.1:1
%             for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2)
%                 [b1, b2] = InitialHighpass(uz, c1, d1);
%                 bp = b1 + I.* b2;
%                 bpsq = bp.sq;
%                 obj = real(bpsq.IntNegReal);
%                 tmp_list(count, 1) = c1;
%                 tmp_list(count, 2) = d1;
%                 tmp_list(count, 3) = obj;
%                 count = count + 1;
%             end
%         end
%         
%         tmpobj = tmp_list(:,3);
%         [bestbp, ind] = min(tmpobj);
%         bestc1 = tmp_list(ind, 1);
%         bestd1 = tmp_list(ind, 2);
%         
%         Best_Table2(row, 1) = t1;
%         Best_Table2(row, 2) = t2;
%         Best_Table2(row, 3) = bestc1;
%         Best_Table2(row, 4) = bestd1;
%         Best_Table2(row, 5) = bestbp;
%         
%         row = row +1;
%         
%         if mod(row, 10) == 0
%             fprintf('\n row = %d, t1=%f, t2=%f', row, t1, t2);
%         end
%     end
% end


%%


% t2 = 3;
% t1 = -2.6;
% 
% [az, uz] = InitialLowpass(t1, t2);
% 
% I = sqrt(-1);
% 
% count = 0;
% for c1 = -1:0.1:1
%     for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2)
%         count = count + 1;
%     end
% end
% 
% tmp_list = ones(count, 3)*inf;
% count = 1;
% 
% for c1 = -1:0.1:1
%     for d1 = -sqrt(1-c1^2):0.1:sqrt(1-c1^2)
%         [b1, b2] = InitialHighpass(uz, c1, d1);
%         bp = b1 + I.* b2;
%         bpsq = bp.sq;
%         obj = real(bpsq.IntNegReal);
%         tmp_list(count, 1) = c1;
%         tmp_list(count, 2) = d1;
%         tmp_list(count, 3) = obj;
%         count = count + 1;
%     end
% end
% 
% tmpobj = tmp_list(:,3);
% [bestbp, ind] = min(tmpobj);
% bestc1 = tmp_list(ind, 1);
% bestd1 = tmp_list(ind, 2);
% 
% [b1, b2] = InitialHighpass(uz, bestc1, bestd1);
% bp = b1 + I.* b2;
% bp2 = bp.sq;
% bp2.fplot

% [b1, b2] = InitialHighpass(uz, c1, d1);
% 
% I = sqrt(-1);
% bp = b1 + I.* b2;
% 
% bp2 = bp.sq;
% bp2.fplot





