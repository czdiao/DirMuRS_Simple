function v = synthesis2d( w, filter2d )
%SYNTHESIS2D Synthesis operation for 2d
%   Input:
%       w:          Decomposed signals. Cell array. num_sig * 1 cells in total.
%                   w{i} is a M*N matrix
%       filter2d:   synthesis filter bank. Struct array. num_sig*1 struct in total.
%   Output:
%       v:          Output signal after synthesis operation
%
%   Note for Normalization:
%       || v ||^2 = \sum || w_i ||^2    (for l2 norm)


num_sig = length(w);
[M, N] = size(w{1});
v = zeros(2*M,2*N);


for i = 1:num_sig
    tmp = d2upsmpl(w{i},2,2,0,0);
%     tmp = d2tconv(tmp, filter2d(i).row_filter, filter2d(i).row_start_pt,...
%         filter2d(i).col_filter, filter2d(i).col_start_pt, 0);
    tmp = d2tconv_fir(tmp, filter2d(i).row_filter, filter2d(i).row_start_pt,...
        filter2d(i).col_filter, filter2d(i).col_start_pt);    
    v = v+tmp;
end

v = v*2;

end

