function nor = CalFilterNormDT2D(FS_filter1d, fb1d, nlevel, Transform, varargin)
%CalFilterNormDT2D
%   Calculate the filter norms of DT-CWT, including splitting the hipass
%   and lowpass transforms.
%
% INPUT :
%        FS_filter1d:
%           First stage filter banks.
%        fb1d:
%           filter banks for both trees.
%        nlevel: 
%           level of decomposition
%        Transform:
%           'DT', 'DT_SplitHigh', 'DT_SplitHighLow'
% Optional Input:
%        varargin{1}:
%           u_hi(2), 2 filters to split the highpass filters.
%        varargin{2}:
%           u_low(2), 2 filters to split the lowpass filters.
% OUTPUT:
%        nor:
%           norm of the multi-level filters.
%
%   Chenzhe Diao
%   Sept, 2015

disp('Calculating Filter Norms:');
tic;

base = 6;   % use small number for fast calculation, but large enough for the signal to be longer than the filters.
nor = cell(1,nlevel);
no = 1;

% load u1,u2 for splitting
switch Transform
    case('DT_SplitHigh')
        u_hi = varargin{1};
        
        for scale = 1:nlevel
            N = base*2^scale;
            x = zeros(N,N);
            W_zero = DualTree2d_SplitHigh(x, scale, FS_filter1d, fb1d, u_hi);
            num_hipass = length(W_zero{1}{1}{1});
            
            for tree1 = 1:2
                for tree2 = 1:2
                    for hipass = 1:num_hipass
                        W = W_zero;
                        W{scale}{tree1}{tree2}{hipass}(no,no) = 1;
                        y = iDualTree2d_SplitHigh(W, scale, FS_filter1d, fb1d, u_hi);
                        nor{scale}{tree1}{tree2}{hipass} = sqrt(sum(sum(abs(y).^2)));
                    end
                end
            end
            fprintf('Level = %d\n', scale);
        end
        
    case('DT_SplitHighLow')
        u_hi = varargin{1};
        u_low = varargin{2};
        
        for scale = 1:nlevel
            N = base*2^scale;
            x = zeros(N,N);
            W_zero = DualTree2d_SplitHighLow(x, scale, FS_filter1d, fb1d, u_hi, u_low);
            num_hipass = length(W_zero{1}{1}{1});
            
            for tree1 = 1:2
                for tree2 = 1:2
                    for hipass = 1:num_hipass
                        W = W_zero;
                        W{scale}{tree1}{tree2}{hipass}(no,no) = 1;
                        y = iDualTree2d_SplitHighLow(W, scale, FS_filter1d, fb1d, u_hi, u_low);
                        nor{scale}{tree1}{tree2}{hipass} = sqrt(sum(sum(abs(y).^2)));
                    end
                end
            end
            fprintf('Level = %d\n', scale);
        end
        
    case('DT')
        
        for scale = 1:nlevel
            N = base*2^scale;
            x = zeros(N,N);
            W_zero = DualTree2d_new(x, scale, FS_filter1d, fb1d);
            num_hipass = length(W_zero{1}{1}{1});
            
            for tree1 = 1:2
                for tree2 = 1:2
                    for hipass = 1:num_hipass
                        W = W_zero;
                        W{scale}{tree1}{tree2}{hipass}(no,no) = 1;
                        y = iDualTree2d_new(W, scale, FS_filter1d, fb1d);
                        nor{scale}{tree1}{tree2}{hipass} = sqrt(sum(sum(abs(y).^2)));
                    end
                end
            end
            fprintf('Level = %d\n', scale);
        end
        
    otherwise
        error('Unknown Transform Type!');
end



disp('Finished Calculating Filter norms!');
toc;

end

