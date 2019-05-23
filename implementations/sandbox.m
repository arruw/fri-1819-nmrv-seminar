I = imread('./resources/vot/vot2014/car/00000200.jpg');
bbox = get_bbox([119   137   204    89]);

figure(1); clf;
imshow(I); hold on;
rectangle('Position',bbox, 'LineWidth',2, 'EdgeColor','y');
hold off;

[P, R] = ratio2area(bbox(3), bbox(4), 512);

S = 33;
a = 1.02;
n = floor(-(S-1)/2):floor((S-1)/2);

Jn = cell(S);%zeros(P,R,S);
f = cell(S);
for s = 1:S
    Jn{s} = imresize(get_patch(I, [bbox(1)+bbox(3)/2 bbox(2)+bbox(4)/2], a^(n(s)), [bbox(3) bbox(4)]), [P R]);
end

figure(2); clf;
montage(Jn, 'Size',[ceil(sqrt(length(Jn))), ceil(sqrt(length(Jn)))]);

figure(3); clf; hold on;
features = hog(single(rgb2gray(Jn{1}/255)),4);
[U,mu,vars] = pca(features);
% imgs = num2cell(features, [1 2]);
% U = reshape(U(:, 1:12), [P R 12]);
% for i = 1:12
%     subplot(3,4,i);
%     imagesc(U(:,:,i));
%     axis off;
%     colormap(gray);
%     set(gca,'dataAspectRatio',[1 1 1]);
%     drawnow;        
% end
% hold off;

Ihsv = rgb2hsv(I);
max(Ihsv(:,:,1), [], 'all')
max(Ihsv(:,:,2), [],'all')
max(Ihsv(:,:,3), [],'all')