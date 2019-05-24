function [state, location] = my_update(state, I, params)
        
    %% translation
    [dx, dy, A_t, B_t] = estimate_translation(I, state, params);
      
    %% scale
    if params.scale
        [ds, A_s, B_s] = estimate_scale(I, state, params);
    else
        ds = 1.0;
    end
    
    %% update state
    state.A_t = (1-params.alpha)*state.A_t + params.alpha*A_t;
    state.B_t = (1-params.alpha)*state.B_t + params.alpha*B_t;

    if params.scale
        state.A_s = (1-params.alpha)*state.A_s + params.alpha*A_s;
        state.B_s = (1-params.alpha)*state.B_s + params.alpha*B_s;
    end
    
    state.bbox_s = scale_bbox([state.bbox_s(1:2)+[dx dy] state.bbox_s(3:4)], ds);
    state.bbox_t = scale_bbox([state.bbox_t(1:2)+[dx dy] state.bbox_t(3:4)], ds);

    state.scale = state.scale * ds;
    
    % location
    location = state.bbox_s;
    
end

function bbox = scale_bbox(bbox, scale)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;
    
    bbox(3:4) = bbox(3:4) * scale;
    bbox(1:2) = [x_c y_c]-bbox(3:4)/2;
end

function [dx, dy, A, B] = estimate_translation(I, state, params)
    % prev object center
    x_c = state.bbox_t(1)+state.bbox_t(3)/2;
    y_c = state.bbox_t(2)+state.bbox_t(4)/2;

    % correlate
    [f, ~] = extract_translation_features(I, state.bbox_t, state.Cw_t, params);
    [y, A, B] = correlate(f, state.Gc_t, state.A_t, state.B_t, params.lambda);
    
    % get next center
    [~, mi] = max(y(:));
    [y_n, x_n] = ind2sub(size(y), mi);
    x_n = x_n + state.bbox_t(1);
    y_n = y_n + state.bbox_t(2);
           
    % get displacement vector
    dx = x_n - x_c;
    dy = y_n - y_c;
end

function [ds, A, B] = estimate_scale(I, state, params)
    [f, ~] = extract_scale_features(I, state.bbox_s, state.Cw_s, params);
    [y, A, B] = correlate(f, state.Gc_s, state.A_s, state.B_s, params.lambda);
    
    [~, mi] = max(y(:));
    scales = params.a.^(-floor((params.S-1)/2):floor((params.S-1)/2));
    ds = scales(mi);
end