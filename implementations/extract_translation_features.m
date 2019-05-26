function [f, d] = extract_translation_features(I, bbox, Cw, model)
%     models = split(model,'+');
%     if numel(models) > 1
%         for i = 1:numel(models)
%             model = models{i};
%             [fi, di] = extract_translation_features(I, bbox, Cw, model);
%             
%             if i == 1
%                 d = di;
%                 f = fi;
%             else
%                 f(:,:,d+1:d+di) = fi;
%                 d = d + di;
%             end
%         end
%         return;
%     end

    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;
    
    switch model
        case 'gray'
            patch = imresize(get_patch(double(rgb2gray(I))/255, [x_c y_c], 1, bbox(3:4)),size(Cw)) .* Cw;
            d = 1;
            f(:,:,1) = patch;
            return;
            
        case 'rgb'
            I = double(I);
            d = 3;
            f = zeros([size(Cw) d]);
            f(:,:,1) = imresize(get_patch(I(:,:,1)/255, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            f(:,:,2) = imresize(get_patch(I(:,:,2)/255, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            f(:,:,3) = imresize(get_patch(I(:,:,3)/255, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            return;
            
        case 'hsv'
            Ihsv = double(rgb2hsv(I));
            d = 3;
            f = zeros([size(Cw) d]);
            f(:,:,1) = imresize(get_patch(Ihsv(:,:,1)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            f(:,:,2) = imresize(get_patch(Ihsv(:,:,2)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            f(:,:,3) = imresize(get_patch(Ihsv(:,:,3)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            return;
            
        case 'luv'
            Iluv = applycform(rgb2xyz(I), makecform('xyz2uvl'));
            d = 3;
            f = zeros([size(Cw) d]);
            f(:,:,1) = imresize(get_patch(Iluv(:,:,1)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            f(:,:,2) = imresize(get_patch(Iluv(:,:,2)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            f(:,:,3) = imresize(get_patch(Iluv(:,:,3)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
            return;
            
        case 'pcahog'
            patch = imresize(get_patch(double(rgb2gray(I))/255 -0.5, [x_c y_c], 1, bbox(3:4)),size(Cw)) .* Cw;
            f_hog = fhog(single(patch), 1);
            f_pca = pca(f_hog(:,:,1:31));
            d = 12;
            f(:,:,1) = patch;
            f(:,:,2:d) = reshape(f_pca(:,1:d-1), [size(Cw) d-1]);
            return;
    end    
end