% extendBoundary :  Extend image on all sides by a specified number of pixels
%
% function r = boundaryExtend(im,Nout,...)
%
% Inputs
% im : input image
% Nout : thickness of border segment in pixels
%
% Outputs
% r : resulting extended image
%
% Selectable parameters :
% 'method' : may be 'reflect' (default), 'reflect2','circular', or 'zeros'
% 'reflect' reflects image across center of border pixels and so 
% does not double the pixels at the boundary.
% 'reflect2' reflects image across outside edge, and so does double pixels
% at boundary
% 'circular' performs circular boundary handling.
% 'zeros' pads with zeros
%
% See also removeBoundary

function r = extendBoundary(im,boundary_size,varargin)
control_params={'method','reflect'};
argselectAssign(control_params);
argselectCheck(control_params,varargin);
argselectAssign(varargin);

[M N]=size(im);

switch method
 case 'reflect'
  rl=fliplr(im(:,2:boundary_size+1));
  rt=flipud(im(2:boundary_size+1,:));
  rr=fliplr(im(:,N-(boundary_size):N-1));
  rb=flipud(im(M-boundary_size:M-1,:));
  rtl=fliplr(flipud(im(2:boundary_size+1,2:boundary_size+1)));
  rtr=fliplr(flipud(im(2:boundary_size+1,N-boundary_size:N-1)));
  rbl=fliplr(flipud(im(M-boundary_size:M-1,2:boundary_size+1)));
  rbr=fliplr(flipud(im(M-boundary_size:M-1,N-boundary_size:N-1)));

 case 'reflect2'
  rl=fliplr(im(:,1:boundary_size));
  rt=flipud(im(1:boundary_size,:));
  rr=fliplr(im(:,N-(boundary_size)+1:N));
  rb=flipud(im(M-boundary_size+1:M,:));
  rtl=fliplr(flipud(im(1:boundary_size,1:boundary_size)));
  rtr=fliplr(flipud(im(1:boundary_size,N-boundary_size+1:N)));
  rbl=fliplr(flipud(im(M-boundary_size+1:M,1:boundary_size)));
  rbr=fliplr(flipud(im(M-boundary_size+1:M,N-boundary_size+1:N)));
  
 case 'circular'
  rl = im(:,N-boundary_size+1:N);
  rt = im(M-boundary_size+1:M,:);
  rr = im(:,1:boundary_size);
  rb = im(1:boundary_size,:);
  rtl = im(M+1-boundary_size:M, N+1-boundary_size:N);
  rtr = im(M+1-boundary_size:M, 1:boundary_size);
  rbr = im(1:boundary_size,1:boundary_size);
  rbl = im(1:boundary_size,N+1-boundary_size:N);
 
 case 'zeros'
  rl=zeros(M,boundary_size);
  rt=zeros(boundary_size,N);
  rr=zeros(M,boundary_size);
  rb=zeros(boundary_size,N);
  rtl=zeros(boundary_size,boundary_size);
  rtr=zeros(boundary_size,boundary_size);
  rbr=zeros(boundary_size,boundary_size);
  rbl=zeros(boundary_size,boundary_size);
  
 otherwise
  error('unknown extension method');
end

r=[[rtl,rt,rtr];[rl,im,rr];[rbl,rb,rbr]];  
