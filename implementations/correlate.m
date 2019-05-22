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

    d = size(f);
    d = d(end);
    
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
    
    y = ifft2(sum(AcF, d) ./ (B + lambda));  % eq. 6
    A = GcF;                                 % part of eq. 5a
    B = sum(FcF, d);                         % part of eq. 5b
end