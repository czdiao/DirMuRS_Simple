function y = d2upsmpl(v,nrow,ncol,row_phase,col_phase)
    y = upsample(v,nrow,row_phase);
    y = upsample(y.',ncol,col_phase);
    y = y.';
end