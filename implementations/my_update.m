function [state, location] = my_update(state, I, params)
    
    I = double(I);

    x_c = state.bbox_t(1)+state.bbox_t(3)/2;
    y_c = state.bbox_t(2)+state.bbox_t(4)/2;
    
    [f, ~] = extract_translation_features(I, state.bbox_t, state.Cw, params);
    [y, A, B] = correlate(f, state.Gc, state.A, state.B, params.lambda);
    
    % get next center
    [m, mi] = max(y(:));
    [y_n, x_n] = ind2sub(size(y), mi);
    x_n = x_n + state.bbox_t(1);
    y_n = y_n + state.bbox_t(2);
           
    % get displacement vector
    dx = x_n - x_c;
    dy = y_n - y_c;
    
    % update state
    state.A = (1-params.alpha)*state.A + params.alpha*A;
    state.B = (1-params.alpha)*state.B + params.alpha*B;
    
    state.bbox_s = [state.bbox_s(1:2)+[dx dy] state.bbox_s(3:4)];
    state.bbox_t = [state.bbox_t(1:2)+[dx dy] state.bbox_t(3:4)];
    state.m = [state.m m];
    
    % location
    location = state.bbox_s;
    
end

function [dx, dy] = estimate_translation(I, state, params)
    f = extract_translation_features(I, statem, params);
    [~] = correlate(f, state, params);
end

function ds = estimate_scale(I, state, params)
    f = extract_scale_features(I, state, params);
end

function bbox = scale_bbox(bbox, scale)
    x_c = bbox(1)+bbox(3)/2;
    y_c = bbox(2)+bbox(4)/2;
    
    bbox(3:4) = bbox(3:4) * scale;
    bbox(1:2) = [x_c y_c]-bbox(3:4)/2;
end

%% TEMP
function ds = estimate_scale1(I, state, params)
    if params.a == 1.0
        ds = 1.0;
        return;
    end

    x_c = state.bbox_s(1)+state.bbox_s(3)/2;
    y_c = state.bbox_s(2)+state.bbox_s(4)/2;

    m = zeros(length(state.n),1);
    parfor n = 1:length(state.n)
        L = imresize(get_patch(I, [x_c y_c], params.a^state.n(n), [state.bbox_s(3) state.bbox_s(4)]), size(state.Cw_s)) .* state.Cw_s;
        Lf = fft2(L);
        Gp = ifft2(Lf .* (state.A_s ./ state.B_s));
        m(n) = max(Gp(:));
    end
    [~, mi] = max(m);
    
    ds = params.a^state.n(mi);
    L = imresize(get_patch(I, [x_c y_c], ds, [state.bbox_s(3) state.bbox_s(4)]), size(state.Cw_s)) .* state.Cw_s;
    Lf = fft2(L);
    Lfc = conj(Lf);
    
    alpha = params.alpha;
    state.A_s = (1-alpha)*state.A_s + alpha*(state.Gf_s .* Lfc);
    state.B_s = (1-alpha)*state.B_s + alpha*((Lf .* Lfc)+params.lambda);
    state.scale = state.scale * ds;
    
    if ds ~= 1.0
       disp("Changed size by: " + ds); 
    end
end
