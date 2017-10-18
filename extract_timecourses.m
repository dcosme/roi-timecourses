%% extract_timecourses.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script extracts FIR timecourses using marsbar for
% subjects defined in $subjects, and rois defined in $rois.
%
% Dependencies: 
%   * spm
%   * marsbar-0.44
%
% Inputs:
%   * ROI(s) must have been extraced from marsbar and save as .mat
%   files. ROI names cannot include dashes(-) and must have the
%   following pattern *_roi.mat
% 
% Output: 
%   * Structure $timecourses saved to $output_dir as a .mat file
%   * Table $datatable saved to $output_dir as a .csv file
% 
% Marsbar code borrowed form this document: 
% http://marsbar.sourceforge.net/marsbar.pdf
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Change directory and source config file
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename)); clear tmp
config

%% Add paths
addpath(spm_path);
addpath(genpath(marsbar_path));

%% Loop through subjects and ROIs and extract time courses
for i = 1:length(subjects)
    for j = 1:length(rois)
        % Define SPM and ROI variables
        sub = subjects(i);
        roi = rois(j);
        roi_mat = sprintf('%s.mat',char(roi));
        spm_name = char(fullfile(sub_dir, sub, fx_file));
        roi_file = char(fullfile(roi_dir,roi_mat));
        
        % Make marsbar design object
        D = mardo(spm_name);
        
        % Make marsbar ROI object
        R = maroi(roi_file);
        
        % Fetch data into marsbar data object
        Y = get_marsy(R, D, 'mean');
        
        % Get contrasts from original design
        xCon = get_contrasts(D);
        
        % Estimate design on ROI data
        E = estimate(D, Y);
        
        % Put contrasts from original design back into design object
        E = set_contrasts(E, xCon);
        
        % Get design betas
        b = betas(E);
        
        % get stats and stuff for all contrasts into statistics structure
        marsS = compute_contrasts(E, 1:length(xCon));

        % Get compound event types structure
        ets = event_types_named(E);
        n_event_types = length(ets);
        
        % Bin size in seconds for FIR
        bin_size = tr(E);

        % Number of FIR time bins to cover length of FIR
        bin_no = fir_length / bin_size;
        
        % Options - here 'single' FIR model, return estimated % signal change
        opts = struct('single', 1, 'percent', 1);
        for e_t = 1:n_event_types
            fir_tc(:, e_t) = event_fitted_fir(E, ets(e_t).e_spec, bin_size, ...
            bin_no, opts);
        end

        % Save in structure
        timecourses.(char(sub)).(char(roi)).tc = fir_tc;
        timecourses.(char(sub)).(char(roi)).events = ets;
        
        % Clear variables
        clearvars -except sub roi timecourses subjects rois fir_length sub_dir roi_dir fx_file i j
    end
end

%% Create a table from data structure
datatable = cell2table(cell(0,5), 'VariableNames', {'subjectID', 'roi', 'condition', 'tr', 'percentSignal'});

for i = 1:numel(subjects)
    for j = 1:numel(rois)
        % Define number of events and TRs
        events = {timecourses.(char(subjects(i))).(char(rois(j))).events(:).name};
        ntr = fir_length / tr_length; 
        
        % Create separate tables for subject, roi, condition, tr, and 
        % timecourse, and join with datatable
        for k = 1:length(events)
            sub = table(repmat(subjects(i),ntr,1), 'VariableNames', {'subjectID'});
            cond = table(repmat(events(k),ntr,1), 'VariableNames', {'condition'});
            roi = table(repmat(rois(j),ntr,1), 'VariableNames', {'roi'});
            tr = table([1:ntr]', 'VariableNames', {'tr'});
            tc = table(timecourses.(char(subjects(i))).(char(rois(j))).tc(:,(k)), 'VariableNames', {'percentSignal'});
            
            % Concatenate all tables into one 'DataTable'
            subTable = horzcat(sub, cond, roi, tr, tc);
            datatable = vertcat(datatable, subTable);
        end
        
    end
end

%% Save structure as a .mat file and table as a .csv file
if ~exist(output_dir,'dir'); mkdir(output_dir); end
save(fullfile(output_dir,'timecourses'),'timecourses');
writetable(datatable, fullfile(output_dir,'timecourses.csv'), 'WriteVariableNames', true);
