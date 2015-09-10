classdef DistOfData
    %DISTOFDATA Distribution of given data as continuous r.v.
    %
    %Example:
    %   x = 0:4;
    %   v = DistOfData(x, 5);
    %
    %   t = -1:0.01:6;
    %   y1 = pdf(v, t); figure; plot(t, y1, '*'); grid on
    %   y2 = cdf(v, t); figure; plot(t, y2, '*'); grid on
    %
    %
    %   Author: Chenzhe Diao
    %   Date:   Aug, 2015
    
    % Note:
    %   Could add expectation, mle, std, etc.
    
    
    properties
        data;   % original sample data
        xbins;  % col vector
        dx;
        pdf_val;% col vector, save the pdf as piecewise value, length=Nbins
        cdf_val;% col vector, length = Nbins+1
    end
    
    methods
        function obj = DistOfData(data, Nbins)
            if nargin == 0
                data = 0;
                Nbins = 10;
            end
            if nargin == 1
                Nbins = 10;
            end
            
            data = data(:);
            obj.data = data;
            lb = min(data);
            ub = max(data);
            obj.dx = (ub-lb)/(Nbins-1);
            obj.xbins = linspace(lb, ub, Nbins)';
            tmp = histc(data, obj.xbins);
            total = length(data);
            obj.pdf_val = tmp/total/obj.dx;
            obj.pdf_val = obj.pdf_val(:);
            
            obj.cdf_val = zeros(Nbins+1,1);
            for i = 1:Nbins
                obj.cdf_val(i+1) = obj.cdf_val(i) + obj.pdf_val(i)*obj.dx;
            end
            
        end
        
        function y = pdf(obj, x)
            % pdf function of the distribution. Realized by query the pdf_val value.
            % right continuous, piecewise constant function
            
            inside = (x>=obj.xbins(1)) & (x<obj.xbins(end)+obj.dx);
            num = floor((x-obj.xbins(1))/obj.dx)+1;
            num = max(num, 1);
            num = min(num, length(obj.pdf_val));
            y = obj.pdf_val(num);
            y = reshape(y, size(x));
            y = y.*inside;
        end
        
        function y = cdf(obj, x)
            % CDF function. Continuous function.
            num = floor((x-obj.xbins(1))/obj.dx)+1;
            num = max(num, 1);
            num = min(num, length(obj.cdf_val));
            y = obj.cdf_val(num);
            y = reshape(y, size(num));
            num = min(num, length(obj.xbins));
            deltax = x - reshape(obj.xbins(num), size(x));
            deltax = deltax.*(deltax>0).*(deltax<obj.dx);
            y = y + deltax.*reshape(obj.pdf_val(num), size(deltax));
            
        end
        
        
    end
    
end

