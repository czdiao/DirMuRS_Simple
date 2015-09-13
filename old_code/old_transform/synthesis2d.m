function v = synthesis2d( w, filterbank2d )
%SYNTHESIS2D Synthesis operation for 2d
%   Input:
%                  w:   Decomposed signals. Cell array. 1*num_sig cells in total.
%                       w{i} is a M*N matrix
%       filterbank2d:   synthesis filter bank. Array of filter2d. 1*num_sig filters in total.
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
    
    if (2*N<length(filterbank2d(i).row_filter))||(2*M<length(filterbank2d(i).col_filter))
        disp('Error: signal is shorter than the filter in synthesis operation!\n');
    end
    %     tmp = d2tconv(tmp, filter2d(i).row_filter, filter2d(i).row_start_pt,...
    %         filter2d(i).col_filter, filter2d(i).col_start_pt, 0);
    tmp = d2tconv_fir(tmp, filterbank2d(i).row_filter, filterbank2d(i).row_start_pt,...
        filterbank2d(i).col_filter, filterbank2d(i).col_start_pt);
    v = v+tmp;
end

v = v*2;

end

