function [f, d] = extract_translation_features(I, bbox, Cw, params)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;
    
    %% GRAY
%     I = double(I);
%     d = 1;
%     f(:,:,1) = imresize(get_patch(I(:,:,1)/255, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
    
    %% RGB
%     I = double(I);
%     d = 3;
%     f = zeros([size(Cw) d]);
%     f(:,:,1) = imresize(get_patch(I(:,:,1)/255, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
%     f(:,:,2) = imresize(get_patch(I(:,:,2)/255, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
%     f(:,:,3) = imresize(get_patch(I(:,:,3)/255, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
    
    %% HSV
    Ihsv = double(rgb2hsv(I));
    d = 3;
    f = zeros([size(Cw) d]);
    f(:,:,1) = imresize(get_patch(Ihsv(:,:,1)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
    f(:,:,2) = imresize(get_patch(Ihsv(:,:,2)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
    f(:,:,3) = imresize(get_patch(Ihsv(:,:,3)/1, [x_c y_c], 1, bbox(3:4)), size(Cw)) .* Cw;
    
    %% PCA HOG
%     patch = double(get_patch(rgb2gray(I), [x_c y_c], 1, bbox(3:4))) .* Cw;
%     features = hog(single(patch/255), 1);
%     f = pca(features);
%     d = 11;
%     f = f(:,1:d);
%     f = reshape(f, [bbox(4:-1:3) d]);
%     
%     figure(5); clf; hold on;
%     for i = 1:12
%         subplot(3,4,i);
%         imagesc(f(:,:,i));
%         axis off;
%         colormap(gray);
%         set(gca,'dataAspectRatio',[1 1 1]);
%         drawnow;        
%     end
%     hold off;

end