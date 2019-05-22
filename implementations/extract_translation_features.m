function [f, d] = extract_translation_features(I, bbox, Cw, params)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;
    
    d = 3;
    f = zeros([size(Cw) d]);
    f(:,:,1) = get_patch(I(:,:,1), [x_c y_c], 1, bbox(3:4)) .* Cw;
    f(:,:,2) = get_patch(I(:,:,2), [x_c y_c], 1, bbox(3:4)) .* Cw;
    f(:,:,3) = get_patch(I(:,:,3), [x_c y_c], 1, bbox(3:4)) .* Cw;
    
%     TODO - not working
%     f = hog(single(get_patch(rgb2gray(I), [x_c y_c], 1, bbox(3:4)) .* Cw), 1);
%     d = 36;
end