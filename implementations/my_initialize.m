function [state, location] = my_initialize(I, region, params)

    % get search bounding box
    bbox_s = get_bbox(region);
    
    % get target bounding box
    bbox_t = round([bbox_s(1)-bbox_s(3)*(2-1)/2 bbox_s(2)-bbox_s(4)*(2-1)/2 bbox_s(3)*2 bbox_s(4)*2]);
    
    %% translation
    % get cosine window
    Cw_t = create_cos_window(bbox_t(3:4));
    
    % get ground truth
    Gc_t = conj(fft2(create_gauss_peak(bbox_t(3:4), params.peak, params.sigma)));
    
    [f_t, d_t] = extract_translation_features(I, bbox_t, Cw_t, params);
    A_t = zeros([size(Cw_t) d_t]);
    B_t = zeros(size(Cw_t));
    [~, A_t, B_t] = correlate(f_t, Gc_t, A_t, B_t, params.lambda);
    
%     %% scale
%     % get cosine window
%     Cw_s = create_cos_window(bbox_s(3:4));
%     
%     % get ground truth
%     Gc_s = conj(fft2(create_gauss_peak(bbox_s(3:4), params.peak, params.sigma)));
%     
%     [f_s, d_s] = extract_scale_features(I, bbox_t, Cw_s, params);
%     A_s = zeros([size(Cw_s) d_s]);
%     B_s = zeros(size(Cw_s));
%     [~, A_s, B_s] = correlate(f_s, Gc_s, A_s, B_s, params.lambda);
    
    %% construct state
    state = struct;  
    % translation
    state.A_t = A_t;
    state.B_t = B_t;
    state.Gc_t = Gc_t;
    state.Cw_t = Cw_t;
    % scale
%     state.A_s = A_s;
%     state.B_s = B_s;
%     state.Gc_s = Gc_s;
%     state.Cw_s = Cw_s;
%     state.scale = 1.0;
    % other
    state.bbox_s = bbox_s;
    state.bbox_t = bbox_t;
    state.m = [params.peak];
    
    % location
    location = bbox_s;
    
end