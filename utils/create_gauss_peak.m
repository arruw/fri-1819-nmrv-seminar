function gauss_peak = create_gauss_peak(sz, max_val, sigma)
% function creates 2-dimmensional Gaussian function
% INPUT:
% sz: size (1d [length] or 2d [width, height])
% max_val: maximum value of the output
% sigma: sigma parameter (scalar real value)
% OUTPUT:
% 1 or 2 dimmensional Gaussian peak
    
if max(size(sz)) == 2

    [rs, cs] = ndgrid((1:sz(2)) - floor(sz(2)/2), (1:sz(1)) - floor(sz(1)/2));
    labels = exp(-0.5 / sigma^2 * (rs.^2 + cs.^2));

    %move the peak to the top-left, with wrap-around
    %labels = circshift(labels, -floor(sz([2,1]) / 2) + 1);
    gauss_peak = max_val * labels;
    
elseif max(size(sz)) == 1
    xs = (1:sz(1)) - floor(sz(1)/2);
    labels = exp(-0.5 / sigma^2 * (xs.^2));
    gauss_peak = max_val * labels';
end

end  % endfunction