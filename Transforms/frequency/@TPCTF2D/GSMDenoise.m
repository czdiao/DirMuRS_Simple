function  W  = GSMDenoise( obj, blocksize, Cwr, Cwi, sigmaN )
%GSMDENOISE Denoising in wavelet domain based on GSM model
%
%   This is performed without parent information.
%
%   Currently for TPCTF transform only, GSM is performed to real/imag part of the
%   coeff separately.
%
%Input:
%   blocksize:
%       integer. normally use 3 or 5.
%   Cwr, Cwi:
%       Noise covariance matrix for real/imaginary part. For example, if
%       the original image noise std is sigmaN, the local noise covariance
%       matrix would be: 
%           sigmaN^2*Cwr{ilevel}{ib}
%       in each band.
%       To calculate Cwr, Cwi, use TPCTF2D.CalCovMatrix().
%   sigmaN:
%       Standard deviation of the noise in the original image.
%
%Output:
%   W:
%       Denoised wavelet coefficients.
%
%
%
%   Chenzhe Diao
%   Jun, 2016
%

if isempty(obj.pairmap)
    pairmap = obj.getpairmap;
    obj.pairmap = pairmap;
else
    pairmap = obj.pairmap;
end

obj.coeff_real = obj.getCoeffReal;
W_real = obj.coeff_real{1};
W_imag = obj.coeff_real{2};

Cwr = RemoveRedundantCw(Cwr, pairmap);
Cwi = RemoveRedundantCw(Cwi, pairmap);

nL = obj.nlevel;
nB = length(W_real{1});


% used in BLSGSM5()
logzmin = -20.5; logzmax = 3.5; Nz = 13;
logz_list = linspace(logzmin,logzmax,Nz);
params.block = [blocksize,blocksize];
params.optim = 1;
params.parent = 0;
params.covariance = 1;


for iL = 1:nL
    for iB = 1:nB
        
        W_real{iL}{iB} = BLSGSM10(W_real{iL}{iB},(sigmaN^2)*Cwr{iL}{iB},logz_list,params);
        W_imag{iL}{iB} = BLSGSM10(W_imag{iL}{iB},(sigmaN^2)*Cwi{iL}{iB},logz_list,params);
                
    end
    fprintf('Finished GSM denoising in level %d\n', iL);
end

obj.coeff_real{1} = W_real;
obj.coeff_real{2} = W_imag;

W = obj.getCoeffComplex;


end

function Cw_new = RemoveRedundantCw(Cw, pairmap)
%Since TPCTF has complex conjugate pairs of bands, and Cw is computed for
%both, one of them is redundant. This function removes the repeated one,
%and reorder them according to pairmap(1,:).

nL = length(Cw);
npair = size(pairmap, 1);
Cw_new = cell(1, nL);
for j = 1:nL
    Cw_new{j} = cell(1, npair);
    for row = 1:npair
        ib = pairmap(row, 1);
        Cw_new{j}{row} = Cw{j}{ib};
    end
end


end



