# roi-timecourses
Code for extracting FIR timecourses for ROIS using marsbar.

For each subject and ROI, a FIR timecourse is extracted and saved as both a matlab structure and a .csv file.

## Dependencies 
* [spm12](http://www.fil.ion.ucl.ac.uk/spm/software/spm12/)
* [marsbar-0.44](https://sourceforge.net/projects/marsbar/files/)

## Key scripts
* `config.m` = specify variables and pathsin this file
* `extract_timecourses.m` = script that extracts the FIR timecourses 

## Inputs
* ROI(s) must have been extraced from marsbar and save as .mat files. ROI names cannot include dashes(`-`) and must have the following pattern `*_roi.mat`
  
## Output
* Structure `$timecourses` saved to `$output_dir` as a .mat file
* Table `$datatable` saved to `$output_dir` as a .csv file

More information about the marsbar code can be found [here](http://marsbar.sourceforge.net/marsbar.pdf)