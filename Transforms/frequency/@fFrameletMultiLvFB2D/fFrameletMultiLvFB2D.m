classdef fFrameletMultiLvFB2D < fFrameletNonSeparable2D
    %FFRAMELETMULTILVFB2D 2D Framelet Transform in frequency domain.
    %This transform is in frequency domain, using nonseparable 2d filter
    %bank freqfilter2d (which is the same as fFrameletNonSeparable2D).
    %
    %   The difference between this class and fFrameletNonSeparable2D is: 
    %   This class take the filters of all transform levels as one filter 
    %   bank, which is input together. Some times we design filter bank in 
    %   this way.
    %
    %
    %
    %
    %
    %   Chenzhe Diao
    %   Jun, 2016
    %
    
    properties
        % Saved in cell(1, nlevel), 
        %       FilterBank2D_MultiLv{1} is the lowpass filter
        %       FilterBank2D_MultiLv{j+1}(nband) is the filter bank for level j.
        % Note: 
        %       FilterBank2D in TPCTF2D is still in use. It is contains the
        %       filters in all levels as a filter bank array. Since the
        %       decomposition and reconstruction is using TPCTF2D in
        %       background implementation, it will be needed there.
        FilterBank2D_MultiLv;
    end
    
    methods     % constructor
        function obj = fFrameletMultiLvFB2D(fb2d_ML)
            obj.type = 'fFrameletMultiLvFB2D';
            if nargin > 0
                obj.FilterBank2D_MultiLv = fb2d_ML; % see its set method
            end
        end
        
    end
    
    
    methods     % set method for FilterBank2D_MultiLv. 
        function obj = set.FilterBank2D_MultiLv(obj, fb2d_ML)
            % It will set 
            %       obj.FilterBank2D_MultiLv
            %       obj.nlevel  
            %       obj.nband   (as an array of len as nlevel, recording number of hipass in each level)
            %       obj.FilterBank2D (as an array to be used in TPCTF2D transform)
            % together.
            obj.FilterBank2D_MultiLv = fb2d_ML;
            obj.nlevel = length(fb2d_ML)-1;     % the first one is lowpass
            obj.nband = zeros(1, obj.nlevel);
            for i = 1:obj.nlevel
                obj.nband(i) = length(fb2d_ML{i+1});
            end
            
            fb2darray = fb2d_ML{1}; % lowpass
            for i = 1:obj.nlevel
                fb2darray = [fb2darray, fb2d_ML{i+1}];
            end
            obj.FilterBank2D = fb2darray;
        end
    end
    
    
    
    methods
        % both need to be tested before use
        w = decomposition(obj, x)
        y = reconstruction(obj)
    end
    
end

