clear;
clc;

params = {
    % Testing training speed alpha
%     create_params(0.007, 'gray', 'my_007_gray'),...
%     create_params(0.010, 'gray', 'my_010_gray'),...
%     create_params(0.013, 'gray', 'my_013_gray'),...
%     create_params(0.016, 'gray', 'my_016_gray'),...
%     create_params(0.019, 'gray', 'my_019_gray'),...
%     create_params(0.022, 'gray', 'my_022_gray'),...
%     create_params(0.025, 'gray', 'my_025_gray'),...
%     create_params(0.028, 'gray', 'my_028_gray'),...
%     create_params(0.031, 'gray', 'my_031_gray')...
    
    % Testing model 'gray'|'rgb'|'hsv'|'luv'|'pcahog'
    create_params(0.019, 'gray',   'my_019_gray'),...
    create_params(0.019, 'rgb',    'my_019_rgb'),...
    create_params(0.019, 'hsv',    'my_019_hsv'),...
    create_params(0.019, 'luv',    'my_019_luv'),...
    create_params(0.019, 'pcahog', 'my_019_pcahog')...
};

cd('./workspace');
trackers = cell(length(params), 1);
for i = 1:length(params)
    create_wrapper(params{i});
    run_experiment;
    delete_wrapper(params{i});
    trackers{i} = params{i}.name;
end
inject_template("./templates/workspace_config.template",struct('name','xyz'), "./workspace_config.m");
set(0,'defaultTextInterpreter','latex');
compare_trackers(trackers);
delete("./workspace_config.m");
cd('..');

function p = create_params(alpha, model_t, name)
    p = struct;
    p.alpha = alpha;           % learning rate
    p.model_t = model_t;         % feature model used ['gray'|'rgb'|'hsv'|'luv'|'pcahog']
    p.name = name;
end

function create_wrapper(p)
    inject_template("./templates/initialize.template",      p, "./"+p.name+"_initialize.m");
    inject_template("./templates/update.template",          p, "./"+p.name+"_update.m");
    inject_template("./templates/workspace_config.template",p, "./workspace_config.m");
end

function delete_wrapper(p)
    delete("./"+p.name+"_initialize.m");
    delete("./"+p.name+"_update.m");
    delete("./workspace_config.m");
end