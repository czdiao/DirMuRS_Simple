function nor = CalFilterNorm(obj, signal_size)
%CALFILTERNORM 
%   Calculate the filter norms of fFrameletTransform2D. 
%   
%   Since it is a frequency based transform, the filter used in each level is
%   theoretically different. So we have to stick to the actual size of the
%   input signal.
%
%Input:
%   signal_size:
%       vector with len=2, the size of the input signal to be tested.
%
%   The Filters are already stored in the obj.
%
%   Chenzhe
%   Feb, 2016
%


if nargin == 1
    signal_size = [512, 512];
end
N1 = signal_size(1);
N2 = signal_size(2);
x = zeros(N1,N2);

nL = obj.level_norm;

nor = cell(1,nL);
no = 1;

for scale = 1:nL
    
    obj.nlevel = scale;
    W_zero = obj.decomposition(x);
    num_hipass = length(W_zero{scale});
    nor{scale} = cell(1, num_hipass);
    
    for hipass = 1:num_hipass
        W = W_zero;
        W{scale}{hipass}(no,no) = 1;
        obj.coeff = W;
        y = obj.reconstruction;
        nor{scale}{hipass} = sqrt(sum(sum(abs(y).^2)));
    end
end


end

