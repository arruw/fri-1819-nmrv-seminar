function demo_tracker()

% TODO: put name oy four tracker here
tracker_name = 'my';
% TODO: select a sequence you want to test on
sequence = 'car';
% TODO: give path to the dataset folder
dataset_path = './resources/vot/vot2014';

params = struct;
params.sigma = 2;
params.peak = 100;
params.psr = 0.05;
params.alpha = 0.025;           % learning rate
params.lambda = 0.01;           % regularization
params.S = 33;                  % # of scales
params.a = 1.02;                % scale factor
params.scale = false;           % estimate scale [true|false]
params.model_t = 'pcahog';      % feature model used ['gray'|'rgb'|'hsv'|'luv'|'pcahog']

use_reinitialization = true;
skip_after_fail = 5;

% specify initialize and update function
initialize = str2func(sprintf('%s_initialize', tracker_name));
update = str2func(sprintf('%s_update', tracker_name));

% read all frames in the folder
base_path = fullfile(dataset_path, sequence);
img_dir = dir(fullfile(base_path, '*.jpg'));

% read ground-truth
% bounding box format: [x,y,width, height]
gt = dlmread(fullfile(base_path, 'groundtruth.txt'));
if size(gt,2) > 4
    % ground-truth in format: [x0,y0,x1,y1,x2,y2,x3,y3], convert:
    X = gt(:,1:2:end);
    Y = gt(:,2:2:end);
    X0 = min(X,[],2);
    Y0 = min(Y,[],2);
    W = max(X,[],2) - min(X,[],2) + 1;
    H = max(Y,[],2) - min(Y,[],2) + 1;
    gt = [X0, Y0, W, H];
end

start_frame = 1;
n_failures = 0;

figure(1); clf; colormap(gray);
frame = 1;
tic;
while frame <= numel(img_dir)
    
    % read frame
    img = imread(fullfile(base_path, img_dir(frame).name));
    
    if frame == start_frame
        % initialize tracker
        cla;
        tracker = initialize(img, gt(frame,:), params);
        bbox = gt(frame, :);
    else
        % update tracker (target localization + model update)
        [tracker, bbox] = update(tracker, img, params);
    end
    
    % show image
    imagesc(rgb2gray(img)); axis image; %set(gca,'dataAspectRatio',[1 1 1]);
    hold on;
    rectangle('Position',bbox, 'LineWidth',2, 'EdgeColor','y');
    % show current number of failures & frame number
    text(3, 15, sprintf('Failures: %d\nFrame: #%d\nFPS: %d', n_failures, frame, round(frame/toc)), 'Color','w', ...
        'FontSize',10, 'FontWeight','normal', ...
        'BackgroundColor','k', 'Margin',1);    
    hold off;
    drawnow;
    
    
    % detect failures and reinit
    if use_reinitialization
        area = rectint(bbox, gt(frame,:));
        if area < eps && use_reinitialization
            disp('Failure detected. Reinitializing tracker...');
            frame = frame + skip_after_fail - 1;  % skip 5 frames at reinit (like VOT)
            start_frame = frame + 1;
            n_failures = n_failures + 1;
        end
    end
    
    frame = frame + 1;
    
end

end  % endfunction

function str = params_to_string(params)
    str = "PARAMETERS:"+newline;
    keys = fieldnames(params);
    for i = 1:numel(keys)
        value = params.(keys{i});
        str = str + keys{i} + "=" + value + newline;
    end
end

