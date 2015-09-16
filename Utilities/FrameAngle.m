function angle = FrameAngle(f1, f2)
% FrameAngle
%   Calculate the cos(theta) = <f1,f2>/(|f1|*|f2|), where f1 and f2 are two
%   matrices of the same size. (also works for vectors.)
%   Chenzhe Diao


if size(f2)~=size(f1)
    error('Frames are not in the same dim!')
end

innerprod = sum(sum(f1.*f2));

norm1 = sqrt(sum(sum(f1.*f1)));
norm2 = sqrt(sum(sum(f2.*f2)));

angle = innerprod/(norm1*norm2);

end