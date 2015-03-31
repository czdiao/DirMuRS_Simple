function ve = extend(v, choice)
%% extend v according to filter's symmetry, NOT boundary extension
% 
%  INPUT :
%      v      : input signal (vector or matrix)
%      choice : extension choice
%            choice = 0 : default periodic extension
%            choice = 1 : endpoints non-repeating (EN) extension
%            choice = 2 : endpoints repeating (ER) extension
%  OUTPUT :
%     ve    : extended signal
% 
%%

if nargin < 2
    choice = 0;
end

[dim_r,dim_c] = size(v);

switch choice
    case 0    %% periodic extension
        ve = v;
    case 1    %% endpoints nonrepeating extension (EN), ve is 2N-2 period
        if dim_r > 1 && dim_c > 1
            % matrix case
            tmp = [v;flipud(v(1:end-1,:))];
            ve  = [tmp fliplr(tmp(:,1:end-1))];
        else
            % vector case
            ve = [v v(end-1:-1:2)];
        end
    case 2    %% endpoints repeating extension (ER), ve is 2N period
        if dim_r > 1 && dim_c > 1
            % matrix case
            tmp = [v;flipud(v)];
            ve = [tmp fliplr(tmp)];
        else
            % vector case
            ve = [v v(end:-1:1)];
        end
    otherwise
        error('extension choice for symmetric filters must be in 0, 1, and 2!');
end

end