function [ w ] = DualTree2d_old( x, J, FS_filter2d, filterbank2d)
%DUALTREE2D Implementation of 2D Dual Tree Complex Wavelet Transform
%   Input:
%	x	   :	input 2d signal
%	J	   :	Level of decompositions to compute
%	FS_filter2d    :	2D Filter bank for first stage decompositon
%	filterbank2d   :	Filter bank for later stages
%
%   Output:
%	w	   :	wavelet coefficients
%		
%   Note:	
%	w{j}{part}{dir}{band}:	
%		j : different level
%		band : different band in one freq corner
%		dir  : dir=1 and dir=2 are symmetric directions
%		part : real or imaginary part (part=dir for real, part~=dir for imaginary)
%
%   Normalized to tight frames
%
%   This function works for any number of highpass filters. (Split Highpass)


w = cell(1, J+1);

x = x/2;   % to normalize to tight frame 

num_hipass = length(filterbank2d{1}{1})-1;


for rowtree = 1:2
    for coltree = 1:2
        
        % First Stage
        LL = analysis2d(x, FS_filter2d{rowtree}{coltree}(1));   % lowpass
        for i = 1:num_hipass     % Hipass
            w{1}{rowtree}{coltree}{i} = analysis2d(x, FS_filter2d{rowtree}{coltree}(i+1));
        end
        
        % Later Stages
        for j = 2:J
            for i = 1:num_hipass     % Hipass
                w{j}{rowtree}{coltree}{i} = analysis2d(LL, filterbank2d{rowtree}{coltree}(i+1));
            end
            LL = analysis2d(LL, filterbank2d{rowtree}{coltree}(1)); % lowpass
        end
        w{J+1}{rowtree}{coltree} = LL;
        
    end
end


for j = 1:J
    for m = 1:num_hipass
        [w{j}{1}{1}{m}, w{j}{2}{2}{m}] = pm(w{j}{1}{1}{m},w{j}{2}{2}{m});
        [w{j}{1}{2}{m}, w{j}{2}{1}{m}] = pm(w{j}{1}{2}{m},w{j}{2}{1}{m});
    end
end


end

