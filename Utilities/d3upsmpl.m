function y = d3upsmpl(v,nx,ny,nz,x_phase,y_phase,z_phase)
    [m0,n0,p0] = size(v);
    m = m0*nx;
    n = n0*ny;
    p = p0*nz;
    y = zeros(m,n,p);
    y(1+x_phase:nx:end,1+y_phase:ny:end,1+z_phase:nz:end) = v;
end