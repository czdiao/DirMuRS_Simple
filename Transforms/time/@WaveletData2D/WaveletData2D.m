classdef WaveletData2D
    %WaveletData Wavelet Coefficients Data
    % Implemented to perform the basic operations and statistics easier for
    % wavelet transform coefficients. Currently should work for:
    %   1. Framelet
    %   2. DualTree
    %   3. DualTree Split
    %
    %   Chenzhe
    %   Dec 2015
    
    properties
        coeff ;     % the wavelet decomposition coefficients
        type = '';  % type of transform:    'Framelet', 'DualTree' (including splitting types)
        nlevel;     % number of levels of decomposition
        nband;
        
        % optional
        frame_rep;  % frame representatives of each band
    end
    
    methods
        % functions to be implemented:
        %   plus, minus, scalar multiplication
        %   data analysis(pdf, cdf), L1, L2, L0 norm
        %   
        
        function obj = WaveletData2D(w, ty)
            %%Constructor of the class.
            % Input:
            %   w:  wavelet coefficients, in cell array
            %           w{ilevel}{iband} for framelet
            %           w{ilevel}{dir1}{real/imag}{iband} for DualTree type
            %   ty: Transform type, in char array. Different transform type
            %       have different data structure for storing the coeff.
            
            obj.coeff = w;
            obj.type = ty;
            obj.nlevel = length(w)-1;
            
            switch(obj.type)
                case('Framelet')
                    obj.nband = length(w{1});
                case('DualTree')
                    obj.nband = length(w{1}{1}{1});
                otherwise
                    error('Unknown Transform Type!');
            end
        end %WaveletData2D constructor
        
        function r = checktype(obj1, obj2)
            %%Return Logical values.
            % If checktype returns false, we cannot do:
            %       obj1 + obj2, or obj1 - obj2
            
            r1 = strcmp(obj1.type,obj2.type);
            r2 = (obj1.nlevel==obj2.nlevel);
            r3 = (obj1.nband==obj2.nband);
            
            r = r1 && r2 && r3;

        end %Check if the 2 Wavelet data are of the same type
        
        function obj_new = plus(obj1, obj2)
            if (~checktype(obj1, obj2))
                error('Different Type in addition!');
            end
            
            ty = obj1.type;
            w1 = obj1.coeff;
            w2 = obj2.coeff;
            w = w1;
            nL = obj1.nlevel;
            nB = obj1.nband;
            
            switch ty
                case 'Framelet'
                    for ilevel = 1:nL
                        for iband = 1:nB
                            w{ilevel}{iband} = w{ilevel}{iband} + w2{ilevel}{iband};
                        end
                    end
                    
                    %Last level lowpass output
                    w{nL+1} = w{nL+1} + w2{nL+1};
                    
                case 'DualTree'
                    for ilevel = 1:nL
                        for dir1 = 1:2
                            for real_imag = 1:2
                                for iband = 1:nB
                                    w{ilevel}{dir1}{real_imag}{iband} =...
                                        w{ilevel}{dir1}{real_imag}{iband} + w2{ilevel}{dir1}{real_imag}{iband};
                                end
                            end
                        end
                    end
                    
                    %Last level lowpass output
                    for dir1 = 1:2
                        for real_imag = 1:2
                            w{nL+1}{dir1}{real_imag} = w{nL+1}{dir1}{real_imag} + w2{nL+1}{dir1}{real_imag};
                        end
                    end
                    
                otherwise
                    error('Unknown transform type!');
            end

            obj_new = WaveletData2D(w, ty);
        end %plus operation
        
        function obj2 = times(C, obj1)
            %%Scalar Multiplication
            %       obj2 = C.*obj1
            
            obj2 = obj1;
            w = obj1.coeff;
            ty = obj1.type;
            nL = obj1.nlevel;
            nB = obj1.nband;
            
            switch ty
                case 'Framelet'
                    for ilevel = 1:nL
                        for iband = 1:nB
                            w{ilevel}{iband} = C*w{ilevel}{iband};
                        end
                    end
                    
                    %Last level output of the lowpass filter
                    w{nL+1} = C*w{nL+1};
                    
                case 'DualTree'
                    for ilevel = 1:nL
                        for dir1 = 1:2
                            for part = 1:2
                                for iband = 1:nB
                                    w{ilevel}{dir1}{part}{iband} = C*w{ilevel}{dir1}{part}{iband};
                                end
                            end
                        end
                    end
                    
                    %Last level output of the lowpass filter
                    for dir1 = 1:2
                        for part = 1:2
                            w{nL+1}{dir1}{part} = C*w{nL+1}{dir1}{part};
                        end
                    end
                    
                otherwise
                    error('Unknown Transform type!');
            end
            
            obj2.coeff = w;
            
        end %Scalar multiplication, dot product.
        
        function obj_new = minus(obj1, obj2)
            %%Implementation of w_new = w1 - w2
            
            if checktype(obj1, obj2)
                obj_new = obj1 + (-1).* obj2;
            else
                error('Different Type in subtraction!');
            end
        end %minus: Subtraction
        
        function v = convert2array(obj)
            %%Convert the coefficients to column array
            
            ty = obj.type;
            nL = obj.nlevel;
            nB = obj.nband;
            w = obj.coeff;
            v = [];
            
            switch ty
                case 'Framelet'
                    for ilevel = 1:nL
                        for iband = 1:nB
                            v = [v; w{ilevel}{iband}(:)];
                        end
                    end
                    
                    %Last level output of the lowpass filter
                    v = [v; w{nL+1}(:)];
                    
                case 'DualTree'
                    for ilevel = 1:nL
                        for dir1 = 1:2
                            for part = 1:2
                                for iband = 1:nB
                                    v = [v; w{ilevel}{dir1}{part}{iband}(:)];
                                end
                            end
                        end
                    end
                    
                    %Last level output of the lowpass filter
                    for dir1 = 1:2
                        for part = 1:2
                            v = [v; w{nL+1}{dir1}{part}(:)];
                        end
                    end
                    
                otherwise
                    error('Unknown Transform type!');
            end
            
        end
        
        function n = norm(obj, p)
            %%Compute the lp norm of the coefficients
            % p could be in [0, inf]
            
            v = obj.convert2array;
            v = abs(v);
            
            if p==0
                n = sum(v>eps);
            elseif p==inf
                n = max(v);
            else
                n = sum(v.^p);
                n = n^(1/p);
            end
        end
        
        
    end
    
end

