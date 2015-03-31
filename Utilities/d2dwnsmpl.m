function y = d2dwnsmpl(v,nrow,ncol,row_phase,col_phase)
   [m,n] = size(v);
   if m < 2 || n < 2
       error('Input should be a 2D matrix!');
   end
   y = downsample(v,nrow,row_phase);
   y = downsample(y.',ncol,col_phase);
   y = y.';
end