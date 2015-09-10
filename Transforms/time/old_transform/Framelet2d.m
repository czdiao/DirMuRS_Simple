function [ w ] = Framelet2d( x, J, FS_filter2d, filterbank2d )
%Framelet2d 2D framelet transform
%   Input:
%	x	:	2D input signal
%	J	:	level of decomposition
%	FS_filter2d :	2D filter bank for first stage transform
%	filerbank2d	:	2D filter bank for later stages transform
%
%   Ouput:
%	w	:	Framelet Coefficients
%			w{j}{band}:	output at each band in level j
%			w{J+1}    :	lowpass output in last level

if nargin == 3  % same filter bank for all levels
    filterbank2d = FS_filter2d;
end

w = cell(1, J+1);

num_hipass = length(filterbank2d)-1;

LL = analysis2d(x, FS_filter2d(1));
for i = 1:num_hipass
    w{1}{i} = analysis2d(x, FS_filter2d(i+1));
end
for j = 2:J
    for i = 1:num_hipass
        w{j}{i} = analysis2d(LL, filterbank2d(i+1));
    end
    LL = analysis2d(LL, filterbank2d(1));
end
w{J+1} = LL;


end

