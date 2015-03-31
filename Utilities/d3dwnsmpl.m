function y = d3dwnsmpl(v,nx,ny,nz,x_phase,y_phase,z_phase)
   [m,n,p] = size(v);
   if m < 2 || n < 2 || p < 2
       error('Input should be a 3D matrix!');
   end
   y = v(1+x_phase:nx:end,1+y_phase:ny:end,1+z_phase:nz:end);
end