% READ_ME.txt: About contents Extract_individual_GM_networks
%
% Author: Betty Tijms, 2015

General:

Note that these scripts require the NIFTI matlab toolbox: This can be downloaded from  http://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
Don't forget to add the path to this toolbox in Matlab.

Please check scripts for * --- ADJUST FOLLOWING ---* to adjust path & file names in the script. Please keep the slahses as indicated.

Extract_individual_GM_networks contains:
1. create_cube_templates.m		This script contains the templates to extract the regions of interest (the cubes) from grey matter.
2.batch_extract_networks.m:		This matlab script extracts individual grey matter networks from grey matter segmentations.
						*Input: c1 or p1 files from SPM5/SPM8/VBM5/VBM8 or pve_1 from FSL (grey matter partial volume estimates) --> names of these stored in a .txt file
						*It uses functions from the folder 'functions' 
						*It is dependent on:
							- Matlab 7 or higher: The script is designed to work with single precision, which is unavailable in earlier versions of Matlab.
							- SPM5 or SPM8 functions --> make sure the path to this software is added to Matlab
							- create_cube_templates.m
4.example_file_withscannames.txt:	Example text file that need to contain the paths+names of the grey matter segmentations.	
3.Functions:				This folder contains matlab functions that are used by 'batch_extract_networks.m' . 
					No adjustment of these files is needed.

INSTRUCTIONS

1. The file create_cube_templates.m needs to be run just once:
	a. Go to the directory where you have write permissions
	b. Run create_cube_templates:
		This will create the directory 'bl_ind' which contains all possible ways to extract 3 x 3 x 3 voxel cubes from a 91 x 109 x 91 image.
		You will have to add this path in to the script batch_extract_networks.m
2  Create a text file that contains the names including the full path of the grey matter segmenations --> like the example in example_file_withscannames.txt
3. Adjust batch_extract_networks.m --> between lines 40 and 60 
4. Run the script.

When you use this toolbox please provide the version number and cite the following paper:
Tijms, BM, Series, P, Willshaw, DJ, & Lawrie, SM. 2012. Similarity-Based Extraction of Individual Networks from Gray Matter MRI Scans. Cerebral cortex, 22, 1530-1541.

If any problems/questions arise please contact me: b.tijms@vumc.nl or betty.tijms@gmail.com
