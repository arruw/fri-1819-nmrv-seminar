function [f, d] = extract_scale_features(I, bbox, Cw, params)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;

    [P, R] = ratio2area(bbox(3), bbox(4), 512);

    scales = params.a.^(-floor((params.S-1)/2):floor((params.S-1)/2));

    I = single(double(rgb2gray(I))/255-0.5);
    
    for s = 1:params.S
        patch = imresize(get_patch(I, [x_c y_c], scales(s), bbox(3:4)), [P R]);
        f_hog = fhog(patch,4);
        f_pca = pca(f_hog(:,:,1:31));
        f_pca = f_pca(:,1:11);
        
        if s == 1
           f = zeros(params.S, numel(f_pca(:)));
        end
        f(s,:) = f_pca(:) * Cw(s);
    end
    f = sum(f,2);
    %f = sum(fft(f, [], 1), 2);
    d = 1;
end