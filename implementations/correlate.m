function [y, A, B] = correlate(f, Gc, A, B, lambda)
% INPUTS
% f  - multidimensional feature (d-diminsional)
% Gc - ground truth, gaussian peak g -> Gc = conj(fft2(g))
% A  - numerator (d-dimensional)
% B  - denumerator
% lambda - regularization term
% OUTPUTS
% y  - score y (new location at maximum)
% A  - new numerator (d-dimensional, no learning rate applied)
% B  - new denumerator (no learning rate applied)

    d = length(size(f));
    if(d == 3)
        d = size(f);
        d = d(end);
    else
        d = 1;
    end
    
    AcF = zeros([size(Gc) d]);
    GcF = zeros([size(Gc) d]);
    FcF = zeros([size(Gc) d]);
    
    for l = 1:d
        F = fft2(f(:,:,l));
        Fc = conj(F);
        AcF(:,:,l) = conj(A(:,:,l)) .* F;
        GcF(:,:,l) = Gc .* F;
        FcF(:,:,l) = Fc .* F;
    end
    
    y = ifft2(sum(AcF, 3) ./ (B + lambda));  % eq. 6
    A = GcF;                                 % part of eq. 5a
    B = sum(FcF, 3);                         % part of eq. 5b
end