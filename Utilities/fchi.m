function y = fchi(x,cL,cR,epsL,epsR,nL,nR,choice)
%% FCHI Characteristic function with smooth modification on both sides
%  FCHI(X,CL,CR,EPSL,EPSR,N,CHOICE) 
%
%% Description
%  fchi(x,cL,cR,epsL,epsR,N,choice) is a function s.t. 
%        fchi =   1;                         for cL+epsL <= x <= cR-epsR;
%        falpha = fbump((x-cL)/epsL);        for  x < cL+epsL;
%        falpha = fbump((-x+cR)/epsR);       for  x > cR-epsR.
%  see fbump for properties of fbump.
%  Condition: epsL+epsR <= cR-cL;
%% Examples
%     x = [-pi:0.01:pi];
%     y1 = fchi(x,-pi/2,pi/2,pi/4,pi/4,2);
%     y2 = fchi(x,pi/2,pi,pi/4,pi/4,2);
%     y3 = fchi(x,-pi,-pi/2,pi/4,pi/4,2);
%     plot(x,y1,'r',x,y2,'b',x,y3,'k',x,y1.^2+y2.^2+y3.^2,'g');
%
%% See also FBUMP
%
%% Copyright
% Copyright (C) 2013. Xiaosheng Zhuang, CityU HK.
% DATE: 2013/05/16

if nargin < 5
    error('Not enough inputs. USAGE: fchi(x,cL,cR,epsL,epsR,N,choice)');
end
if nargin < 6
    nL = 1;
    nR = 1;
end
if nargin < 8
    choice = 1;
end

if (epsL<=0) || (epsR<=0)
    error('Smoothing radius is not positive!');
end

if cR-cL < epsL+epsR
    error('fchi(x,cL,cR,epsL,epsR,nL,nR,choice) must be with cR-cL>=epsL+epsR!');
end


y = (x <= cR-epsR).*(x >= cL+epsL);
y = y + fbump((x-cL)/epsL,nL,choice).*(x < cL+epsL);
y = y + fbump((-x+cR)/epsR,nR,choice).*(x > cR-epsR);

end
