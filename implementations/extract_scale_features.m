function [f, d] = extract_scale_features(I, bbox, Cw, params)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;
    
    [w, h] = bbox(3:4);
    n = -floor((params.S-1)/2):floor((params.S-1)/2);
    d = length(n);
    f = zeros(w,h,d);
    a = params.a;  
    for l = 1:d
        f(:,:,l) = imresize(get_patch(I, [x_c y_c], a^n(l), [w, h]), size(Cw)) .* Cw;
    end
end