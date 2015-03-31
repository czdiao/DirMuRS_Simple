% argselectAssign : assign variables in calling workspace
%
%  function argselectAssign(variable_value_pairs)
%  
%  Inputs : 
%  variable_value_pairs is a cell list of form
%  'variable1',value1,'variable2',value2,...
%  This function assigns variable1=value1 ... etc in the *callers* workspace
%
%  This is used at beginning of function to simulate keyword argument
%  passing. Typical usage is
%
%  argselectAssign(control_params);
%  argselectCheck(control_params,varargin);
%  argselectAssign(varargin);
%
%  where control_params is a cell list of variable,value pairs containing
%  the default parameter values.
% 
%  See also argselectCheck
function argselectAssign(variable_value_pairs)
for j =1:2:length(variable_value_pairs)
  pname=variable_value_pairs{j};
  pval=variable_value_pairs{j+1};
  assignin('caller',pname,pval);
end
