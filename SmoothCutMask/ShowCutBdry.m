function ShowCutBdry( orig_image, mask, iscolor )
%SHOWCUTBDRY Show The boundary of the smooth mask on the original image.
%
%
%   Chenzhe
%   Feb, 2016
%

if nargin==2
    iscolor = false;
end

pos = (mask>eps) & (mask<(1-eps));

if iscolor
    orig_image(pos) = max(max(orig_image));
    ShowImageColor(orig_image)
else
    orig_image(pos) = min(min(orig_image));
    ShowImage(orig_image);
end




end

