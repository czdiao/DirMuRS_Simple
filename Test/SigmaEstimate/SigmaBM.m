function sigma = SigmaBM(Sigmay2, noiselevel)
if noiselevel==5
    load('SigmaCal5.mat', 'Wsig', 'Ssig');
    sigma = interp1(Wsig, Ssig, Sigmay2,'linear','extrap');
    
elseif noiselevel == 100
    load('SigmaCal100.mat','Wsig', 'Ssig');
    sigma = interp1(Wsig, Ssig, Sigmay2,'linear','extrap');

else
    error('Wrong noise level');


end