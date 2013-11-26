function [nz, nan_count, off_set] = determine_rois_with_minimumNZ(CN_a2, bl_dir, n, Sa, t_result_dir)

% Author: Betty Tijms 19.01.11
%% Extract the regions of interest according to 'template' bl_ind.
% CN_a2 - list of the directories of the bl_ind --> the bl_ind with different off_sets
% n - the dimensions of the cubes (just one scalar)
% bl_dir - the main directory of the bl_ind
% Sa - the data file of the scan of which the off_set & nz needs to be determined of

numimages2=size(CN_a2,1);

% Dimensions of the cubes
s=n^3;
% For each person:
% 	loop through the dirs and create 
% 	bind
% 	check if nz is smaller than the one before. If so --> make a note of which bl_ind this is.

%Make an array to store nz in
all_nz=single(zeros(numimages2,2));

% Store current directory
tempd1=t_result_dir;

% go to the bl_ind directory
cd(bl_dir)

% Loop through the bl_inds and get the rois --> determine which off_set will give the minimum number of cubes
for im2=1:numimages2
	tempd2=char(CN_a2(im2));
	t=strcat(tempd2,'/data/bl_ind.m');
	t2=strcat(tempd1,'/data/bind.m');

	%Load the corresponding bl_ind
	load(t)

	% Write the corresponding bind (array that contains all non-zero-variance cube indices) (delete such a file first)
	delete(t2);
	fid=fopen(t2, 'a');
	if fid < 0
		'Unable to write bind.m in bl_ind directory, please check whether you have writing permission and/or whether path to bl_ind is correct'
		break
	end
	
	l=length(bl_ind);

	%create bind --> the block index of non_zero and var!=0 blocks
	%block size
	%s=n^3;
	tind=zeros(27,1);
	tnz=0;
	tnan_count=0;
	varnan=0;
	
	%tic
	for i=1:s:l
		%store indices
		tind=bl_ind(i:(i+s-1));
		%length(tind) %debug check whether length is correct
		%ignore all zero blocks and var=0 blocks any(Sa(tind)~=0) | 
		if var(Sa(tind))==0 
			if all(Sa(tind))~=0
				tnan_count=tnan_count+1;
			end
		%    varnan=1;
		%%% DEBUG
		%Sa(tind)
		%break
		else
			% Save only these indices for bind
			%fprintf(fid, '%d \n', tind); %from previous version
			tnz=tnz+1;
		end
		varnan=0;
	end

	% Close fid
	fclose(fid);

	% Store nz in array
	all_nz(im2,:)=[tnz tnan_count];
		
	%save data/nz.m nz;
	%save data/nan_count.m nan_count; 
	clear ('bl_ind', 'tnz', 'tnan_count','tind');
end

[mi mj]=min(all_nz(:,1));

%Store the nz, nan_count and the corresponding bl_ind offset
nz=all_nz(mj,1);
nan_count=all_nz(mj,2);

mj=2;

% Get the corresponding off_set and srote this too.
off_set=CN_a2(mj);

% Store this bind into subjects own directory
tempd2=char(CN_a2(mj));
t=strcat(tempd2,'/data/bl_ind.m');
t2=strcat(tempd1,'/data/bind.m');

%Load the corresponding bl_ind
load(t)

% Write the corresponding bind (array that contains all non-zero-variance cube indices) (delete such a file first)
delete(t2);
fid=fopen(t2, 'a');
	
l=length(bl_ind);

%create bind --> the block index of non_zero and var!=0 blocks
%block size
%s=n^3;
tind=zeros(27,1);

%tic
for i=1:s:l
	%store indices
	tind=bl_ind(i:(i+s-1));
	%length(tind) %debug check whether length is correct
	%ignore all zero blocks and var=0 blocks any(Sa(tind)~=0) | 
	if var(Sa(tind))~=0 
		fprintf(fid, '%d \n', tind); 
	end

end

% Close fid
fclose(fid);

cd (tempd1)