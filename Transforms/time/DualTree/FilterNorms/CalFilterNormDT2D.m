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
%           'DT', 'DT_SplitHigh', 'DT_SplitHighLow', 'DT_SplitHighLowComplex'
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

% disp('=====================Calculating Filter Norms:=========================');
fprintf('\nCalculating Filter Norms:');
fprintf('\tLevel = ');
tic;

base = 6;   % use small number for fast calculation, but large enough for the signal to be longer than the filters.
nor = cell(1,nlevel);
no = 1;


switch Transform
    case('DT')
        transform_func = @(x, scale) DualTree2d(x, scale, FS_filter1d, fb1d);
        itransform_func = @(W, scale) iDualTree2d(W, scale, FS_filter1d, fb1d);
    case('DT_SplitHigh')
        u_hi = varargin{1};
        transform_func = @(x, scale) DualTree2d_SplitHigh(x, scale, FS_filter1d, fb1d, u_hi);
        itransform_func = @(W, scale) iDualTree2d_SplitHigh(W, scale, FS_filter1d, fb1d, u_hi);
    case('DT_SplitHighLow')
        u_hi = varargin{1};
        u_low = varargin{2};
        transform_func = @(x, scale) DualTree2d_SplitHighLow(x, scale, FS_filter1d, fb1d, u_hi, u_low);
        itransform_func = @(W, scale) iDualTree2d_SplitHighLow(W, scale, FS_filter1d, fb1d, u_hi, u_low);
    case('DT_SplitHighLowComplex')
        u_hi = varargin{1};
        u_low = varargin{2};
        transform_func = @(x, scale) DualTree2d_SplitHighLowComplex(x, scale, FS_filter1d, fb1d, u_hi, u_low);
        itransform_func = @(W, scale) iDualTree2d_SplitHighLowComplex(W, scale, FS_filter1d, fb1d, u_hi, u_low);
    otherwise
        error('Unknown Transform Type!');
end

for scale = 1:nlevel
    N = base*2^scale;
    x = zeros(N,N);
    W_zero = transform_func(x, scale);
    num_hipass = length(W_zero{1}{1}{1});
    
    for tree1 = 1:2
        for tree2 = 1:2
            for hipass = 1:num_hipass
                W = W_zero;
                W{scale}{tree1}{tree2}{hipass}(no,no) = 1;
                y = itransform_func(W, scale);
                nor{scale}{tree1}{tree2}{hipass} = sqrt(sum(sum(abs(y).^2)));
            end
        end
    end
    fprintf('    %d,', scale);
end

fprintf('\n');

ElapsedTime = toc;

disp(['Finished Calculating Filter norms in ', num2str(ElapsedTime), ' seconds!']);

% disp('==============================================');

end

