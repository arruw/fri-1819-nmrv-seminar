function [h, w] = ratio2area(h, w, area)
    r = h/w;
    
    w = ceil(sqrt(area * r));
    h = ceil(sqrt(area / r));
end

