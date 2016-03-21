classdef fDualTree2D  <  DualTreeWavelet2D
    %FDUALTREE2D 2D Dual Tree CWT. The transform is implemented in
    %frequency domain. The Filters are given in frequency domain. So we
    %could use IIR filters.
    %
    %   Since the coeff data is still saved in real (real/imag part
    %   respectively), all the data structure and manipulation to the data
    %   methods remain the same. We only need to implement the transform
    %   and inverse transform again. All the other properties and methods
    %   inherit from DualTreeWavelet2D class.
    %   The only properties changed here is the filter bank. The filter
    %   bank contains filters in the class of freqfilter1d.
    %
    %   Chenzhe
    %   Feb, 2016
    
    properties
        isSameRowColFB = true;  % assign false for adaptive filter banks
        FirstStageFB_col;
        FisrtStageFB_row;
        FilterBank_col;
        FilterBank_row;
    end
    
    methods     % Constructor
        function obj = fDualTree2D(FSFB, FB)    % Constructor
                obj = obj@DualTreeWavelet2D();
                obj.type = 'fDualTree2D';
                obj.nband = 3;
                if nargin >0
                    obj.FirstStageFB = FSFB;
                    obj.FilterBank = FB;
                end
        end
    end
    
    methods
        w = decomposition(obj, x)
        y = reconstruction(obj)
        
    end
    
    methods(Static)
        wf = wfft2_dt( wt )
        wt = wifft2_dt( wf )
    end
    
end

