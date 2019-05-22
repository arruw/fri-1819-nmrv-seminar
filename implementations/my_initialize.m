function [state, location] = my_initialize(I, region, params)

    I = double(I);

    % get search bounding box
    bbox_s = get_bbox(region);
    
    % get target bounding box
    bbox_t = round([bbox_s(1)-bbox_s(3)*(2-1)/2 bbox_s(2)-bbox_s(4)*(2-1)/2 bbox_s(3)*2 bbox_s(4)*2]);
    
    %% translation
    % get cosine window
    Cw = create_cos_window([bbox_t(3) bbox_t(4)]);
    
    % get ground truth
    Gc = conj(fft2(create_gauss_peak([bbox_t(3) bbox_t(4)], params.peak, params.sigma)));
    
    [f, d] = extract_translation_features(I, bbox_t, Cw, params);
    A = zeros([size(Cw) d]);
    B = zeros(size(Cw));
    [~, A, B] = correlate(f, Gc, A, B, params.lambda);
    
    %% construct state
    state = struct;  
    % translation
    state.A = A;
    state.B = B;
    state.Gc = Gc;
    state.Cw = Cw;
    % scale
    % TODO
    % other
    state.bbox_s = bbox_s;
    state.bbox_t = bbox_t;
    state.m = [params.peak];
    
    % location
    location = bbox_s;
    
end