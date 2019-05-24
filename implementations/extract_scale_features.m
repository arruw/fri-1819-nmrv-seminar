function [f, d] = extract_scale_features(I, bbox, Cw, params)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;

    [P, R] = ratio2area(bbox(3), bbox(4), 512);

    scales = params.a.^(-floor((params.S-1)/2):floor((params.S-1)/2));

    I = single(double(rgb2gray(I))/255-0.5);
    
    f = zeros(params.S, floor(P/4)*floor(R/4)*36);
    for s = 1:params.S
        patch = imresize(get_patch(I, [x_c y_c], scales(s), bbox(3:4)), [P R]);
        f(s,:) = reshape(hog(patch,4), 1, []);
    end
    f = sum(fft(f'))';
    d = 1;
end