%% config.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script specifies the variables used in
% extract_timecourses.m
%
% Inputs:
%   * ROI(s) must have been extraced from marsbar and save as .mat
%   files. ROI names cannot include dashes(-) and must have the
%   following pattern *_roi.mat
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specify variables to use in extract_timecourses.m
% Define variables
subjects = {'FP001', 'FP002', 'FP003', 'FP004', 'FP005', 'FP006', 'FP007', 'FP008', 'FP009', 'FP010', 'FP011', 'FP012', 'FP013', 'FP014', 'FP015', 'FP016', 'FP018', 'FP019', 'FP020', 'FP021', 'FP022', 'FP023', 'FP024', 'FP025', 'FP026', 'FP027', 'FP028', 'FP029', 'FP030', 'FP031', 'FP032', 'FP034', 'FP035'}; %Add subjects IDs here
rois = {'RL_CBLM_roi', 'RL_DLPFC_roi', 'RL_IFG_roi', 'RL_SFG_roi', 'RL_SMA_roi'}; % ROI name exclusing '.mat'
fir_length = 20; % length of FIR in seconds
tr_length = 2;
        
% Define paths
sub_dir = '/Volumes/psych-cog/dsnlab/FP/BDX_univariate/subjects';
roi_dir = '/Volumes/psych-cog/dsnlab/FP/BDX_univariate/ROI/marsbar';
fx_file = 'fx/fx_standard/SPM.mat';
output_dir = '/Volumes/psych-cog/dsnlab/FP/BDX_univariate/timecourses';

% Add paths
spm_path = '/Users/Shared/spm12';
marsbar_path = '/Users/Shared/spm12/toolbox/marsbar-0.44';
