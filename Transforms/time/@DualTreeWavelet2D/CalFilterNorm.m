function nor = CalFilterNorm( obj )
%CALFILTERNORM 
%   Calculate the filter norms of DT-CWT, including splitting the hipass
%   and lowpass transforms.
%
%   The Filters are already stored in the obj.
%
%   Chenzhe
%   Jan, 2016


nL = obj.level_norm;

base = 6;   % use small number for fast calculation, but large enough for the signal to be longer than the filters.
nor = cell(1,nL);
no = 1;

obj_new = obj;

for scale = 1:nL
    N = base*2^scale;
    x = zeros(N,N);
    
    obj_new.nlevel = scale;
    W_zero = obj_new.decomposition(x);
    num_hipass = length(W_zero{1}{1}{1});
    
    for tree1 = 1:2
        for tree2 = 1:2
            for hipass = 1:num_hipass
                W = W_zero;
                W{scale}{tree1}{tree2}{hipass}(no,no) = 1;
                obj_new.coeff = W;
                y = obj_new.reconstruction;
                nor{scale}{tree1}{tree2}{hipass} = sqrt(sum(sum(abs(y).^2)));
            end
        end
    end
end





end

