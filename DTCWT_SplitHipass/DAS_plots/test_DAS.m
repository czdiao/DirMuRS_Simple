clear;

nlevel = 4;     % level of decomposition
L = 4*2^(nlevel+1);

x = zeros(L,L);
[FS_filter2d, filter2d] = DualTreeFilter2d_SplitHipass;
w = DualTree2d(x, nlevel, FS_filter2d, filter2d);

figure;


for J = 3:3
    N = L/2^J;
    
    
    count = 0;
    for nband = 4:4
        
        for d2 = 1:1
            % Imaginary
            d1 = mod(d2,2)+1;
            
            %%
            subplot_tight(2,2,1);
            w{J}{d1}{d2}{nband}(N/2-1, N/2-1) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J}{d1}{d2}{nband}(N/2-1, N/2-1) = 0;
            surf(y1); hold on;
            
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
            surf(y1);
            xlim([1,L]);
            ylim([1,L]);
            
            %%
            subplot_tight(2,2,2);
            w{J}{d1}{d2}{nband}(N/2-1, N/2) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J}{d1}{d2}{nband}(N/2-1, N/2) = 0;
            surf(y1); hold on;
            
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
            surf(y1);
            xlim([1,L]);
            ylim([1,L]);
            
            
            %%
            subplot_tight(2,2,3);
            w{J}{d1}{d2}{nband}(N/2, N/2-1) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J}{d1}{d2}{nband}(N/2, N/2-1) = 0;
            surf(y1); hold on;
            
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
            surf(y1);
            xlim([1,L]);
            ylim([1,L]);
            
            %%
            subplot_tight(2,2,4);
            w{J}{d1}{d2}{nband}(N/2, N/2) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J}{d1}{d2}{nband}(N/2, N/2) = 0;
            surf(y1); hold on;
            
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 1;
            y1 = iDualTree2d(w,nlevel, FS_filter2d, filter2d);
            w{J+1}{d1}{d2}{nband}(N/4, N/4) = 0;
            surf(y1);
            xlim([1,L]);
            ylim([1,L]);
        end
        
    end
end















