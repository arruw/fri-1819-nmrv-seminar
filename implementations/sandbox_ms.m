clear; clc;

I = imread('./resources/vot/vot2014/car/00000200.jpg');
I_n = imread('./resources/vot/vot2014/car/00000201.jpg');
bbox_s = get_bbox([119   137   204    89]);

if mod(bbox_s(3), 2) == 0; bbox_s(3) = bbox_s(3)+1; end
if mod(bbox_s(4), 2) == 0; bbox_s(4) = bbox_s(4)+1; end

bbox_t = round([bbox_s(1)-bbox_s(3)*(2-1)/2 bbox_s(2)-bbox_s(4)*(2-1)/2 bbox_s(3)*2 bbox_s(4)*2]);

x_c = bbox_s(1)+bbox_s(3)/2;
y_c = bbox_s(2)+bbox_s(4)/2;

patch = get_patch(I, [x_c y_c], 1, bbox_s(3:4));
patch_n = get_patch(I_n, [x_c y_c], 1, bbox_s(3:4));

kernel = create_epanechnik_kernel(bbox_s(4), bbox_s(3), 0.2);
p = extract_histogram(patch_n, 9, kernel);

weights = backproject_histogram(patch_n, v);

figure(1); clf;
imshow(patch_n);

figure(2); clf;
imagesc(weights);