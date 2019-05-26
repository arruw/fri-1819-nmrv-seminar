clear; clc;

I = imread('./resources/vot/vot2014/car/00000200.jpg');
I_n = imread('./resources/vot/vot2014/car/00000210.jpg');
bbox_s = get_bbox([119   137   204    89]);
bbox_t = round([bbox_s(1)-bbox_s(3)*(2-1)/2 bbox_s(2)-bbox_s(4)*(2-1)/2 bbox_s(3)*2 bbox_s(4)*2]);

Cw = create_cos_window(bbox_t(3:4));
Gc = conj(fft2(create_gauss_peak(bbox_t(3:4), 100, 2)));
[f, d] = extract_translation_features(I, bbox_t, Cw, 0);
A = zeros([size(Cw) d]);
B = zeros(size(Cw));
[y, A, B] = correlate(f(:,:,2:28), Gc, A(:,:,2:28), B, 0.01);

[f_n, d_n] = extract_translation_features(I_n, bbox_t, Cw, 0);
[y_n, A_n, B_n] = correlate(f_n(:,:,2:28), Gc, A, B, 0.01);

bbox = [bbox_s(1:2)-bbox_t(1:2) bbox_s(3:4)]

figure(1); clf;
subplot(3, 1, 1);
    imagesc(f(:,:,1)); colormap(gray); set(gca,'dataAspectRatio',[1 1 1]);
    hold on; rectangle('Position',bbox, 'LineWidth',2, 'EdgeColor','y'); hold off;
subplot(3, 1, 2);
    imagesc(f_n(:,:,1)); colormap(gray); set(gca,'dataAspectRatio',[1 1 1]);
    hold on; rectangle('Position',bbox, 'LineWidth',2, 'EdgeColor','y'); hold off;
subplot(3, 1, 3);
    imagesc(y_n); colormap(gray); set(gca,'dataAspectRatio',[1 1 1]);
