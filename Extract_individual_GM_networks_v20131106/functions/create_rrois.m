function [rrois, rlookup]= create_rrois (rois, n, Sa, Va, off_set, bind, bl_dir, nz);
% Create a null model == rois with all spatial information removed.
% Compute correlation index for full matrix
% Note that when you start to rotate, the max index of correlation is not necessarily the same any more

% Total number of voxels present
s=n^3;

% Load the corresponding bl_ind
t=char(strcat(bl_dir, off_set, '/data/bl_ind.m'));

load(t)
clear t

% Start at the first non- empty voxel to create the random rois
tind=find(bl_ind==min(bind));
ind=bl_ind(tind:tind+length(bind)-1);

% Create a random image
cSa=Sa*0;
rp=randperm(length(bind));
cSa(ind)=Sa(bind(rp));

c=Va;
c.img=cSa;
%c.fname=strcat(tempd, '/scramble.img');
%save_nii(c,'images/scramble.nii');


% create appropriate ROIS for this image
lb=length(ind);
col=1;

rrois=zeros(s,nz,'single');
rlookup=zeros(s,nz,'single');
		
%go through bind for indices of voxel that belong to each ROI
% lb is the last voxel that belongs to a roi
%lookup is lookup table to go from corr index to bind to Sa
st=s;
for i=1:st:lb
	rrois(:,col)=cSa(ind(i:(i+(st-1))));
	rlookup(:,col)=i:(i+(st-1));
	col=col+1;
end

%save data/rotation/rrois.m rrois
%save data/rotation/rlookup.m rlookup
