classdef FFBindex
    %FFBINDEX Index conversion of the 2D freq filter bank.
    %
    %   We have 3 types of indices of each filter:
    %       lindex:
    %           linear index. position in the filter bank
    %       cindex:
    %           2d index. Use positive/negative integer/half integer to
    %           mark the position in the frequency domain. Stored in
    %           freqfilter2d class.
    %       index2d:
    %           2d index. Positive integers to find MarkMatrix(index2d) and
    %           IndexMatrix(index2d) elements.
    %
    %   Chenzhe Diao
    %   Mar, 2016
    %
    
    properties
        fb2d;
        MarkMatrix;     % logical matrix, if the filter covering the frequency location is still in the filter bank
        IndexMatrix;    % store the lindex of the filter in the filter bank
        EnergyMatrix;
        seq;        % first row for linear index, second row for energy
        Norm2Matrix;    % Matrix storing the l2 norm of the filters
    end
    
    methods
        function obj = FFBindex(m, n, fb2d)   % constructor, m, n are the size of the filter bank matrix
            if nargin >=2
                obj.MarkMatrix = false([m, n]);
                obj.IndexMatrix = zeros(m, n);
                obj.EnergyMatrix = zeros(m, n);
                obj.Norm2Matrix = zeros(m, n);
                if nargin ==3
                    obj.fb2d = fb2d;
                    len = length(fb2d);
                    obj.seq = zeros(2,len);
                    obj.seq(1,:) = 1:len;
                    for i = 1:len
                        cindex = fb2d(i).index;
                        [ii, jj] = obj.cindex2index2d(cindex);
                        obj.MarkMatrix(ii, jj) = true;
                        obj.IndexMatrix(ii, jj) = i;
                        obj.EnergyMatrix(ii,jj) = fb2d(i).EnergyPortion;
                        obj.Norm2Matrix(ii, jj) = fb2d(i).norm2;
                        obj.seq(2,i) = fb2d(i).EnergyPortion;
                    end
                end
            end
        end
    end
    
    
    methods
        % index conversion
        function [i1, i2] = cindex2index2d(obj, cindex)
            % From 2d cindex (used in freqfilter2d) to +int matrix
            % index (index2d) used in MarkMatrix, IndexMatrix
            
            i = cindex(1);
            j = cindex(2);
            [n1, n2] = size(obj.MarkMatrix);
            % index2d
            i1 = i+n1/2+1/2;
            i2 = j+n2/2+1/2;            
        end
        
        % find all unremoved filters(lindex) neighbour to a given filter
        function neighbour = FindNeighbour(obj, lindex)
            fb = obj.fb2d;
            cindex = fb(lindex).index;
            [ii, jj] = obj.cindex2index2d(cindex);
            
            [M, N] = size(obj.MarkMatrix);
            ilow = max(ii-1, 1);
            iup = min(ii+1, M);
            jlow = max(jj-1, 1);
            jup = min(jj+1, N);
            
            neighbour  = [];
            for r = ilow:iup
                for c = jlow:jup
                    if obj.MarkMatrix(r, c)
                        nblindex = obj.IndexMatrix(r, c);
                        neighbour = [neighbour, nblindex];
                    end
                end
            end
            
        end
        
        % find all unremoved filters(lindex) neighbour to a filter group
        function neighbour = FindNeighbourGroup(obj, grouplindex)
            %  The output could contain repeated filters
            len = length(grouplindex);
            neighbour = [];
            for i = 1:len
                lindex = grouplindex(i);
                neighbour = [neighbour, FindNeighbour(obj, lindex)];
            end
            
        end
        
        
    end
    
end

