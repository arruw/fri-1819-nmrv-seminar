function [state, location] = my_update(state, I, params)
    
    x_c = state.bbox_t(1)+state.bbox_t(3)/2;
    y_c = state.bbox_t(2)+state.bbox_t(4)/2;
    
    [f, ~] = extract_translation_features(I, state.bbox_t, state.Cw_t, params);
    [y, A_t, B_t] = correlate(f, state.Gc_t, state.A_t, state.B_t, params.lambda);
    
    % get next center
    [m, mi] = max(y(:));
    [y_n, x_n] = ind2sub(size(y), mi);
    x_n = x_n + state.bbox_t(1);
    y_n = y_n + state.bbox_t(2);
           
    % get displacement vector
    dx = x_n - x_c;
    dy = y_n - y_c;
        
    % update state
    state.A_t = (1-params.alpha)*state.A_t + params.alpha*A_t;
    state.B_t = (1-params.alpha)*state.B_t + params.alpha*B_t;
    
    state.bbox_s = [state.bbox_s(1:2)+[dx dy] state.bbox_s(3:4)];
    state.bbox_t = [state.bbox_t(1:2)+[dx dy] state.bbox_t(3:4)];
    state.m = [state.m m];
    
    % location
    location = state.bbox_s;
    
end

function bbox = scale_bbox(bbox, scale)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;
    
    bbox(3:4) = bbox(3:4) * scale;
    bbox(1:2) = [x_c y_c]-bbox(3:4)/2;
end