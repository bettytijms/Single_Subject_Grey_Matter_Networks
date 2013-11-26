function [rotcorr, rrcorr] = fast_cross_correlation(rois, rrois, dim,forty)

angles=rotation_xyz(dim,forty);

corr=zeros(size(rois,2),'single');
%rot_angle=zeros(size(rois,2),'single');

rcorr=zeros(size(rrois,2),'single');
%rot_rangle=zeros(size(rrois,2),'single');

% Construct numerator and denumerator tables, that contain precomputed sums

% n sum contains c_ij - mean(c_j) --> so the mean of the particular column subtracted from all the cells in that column.

% Get the mean and put in a matrix with the same size as rois
mean_rois=mean(rois);
% t_mean_mat=mean_rois(ones(1,size(rois,1)),:); % This is same as below, but slightly slower
t_mean_mat=ones(size(rois,1),1)*mean_rois;	%repmat is also possible but this is a bit faster (don't understand why).
n_sum= rois-t_mean_mat;

% d_sum is basically n_sum squared and then the root
% NOTE need to sum over squared values before taking sqrt!!!
d_sum= sqrt(sum(n_sum.^2));

% Random: Get the mean and put in a matrix with the same size as rois
rmean_rois=mean(rrois);
rt_mean_mat=ones(size(rrois,1),1)*rmean_rois;
rn_sum= rrois-rt_mean_mat;

% d_sum is basically n_sum squared and then the root
rd_sum= sqrt(sum(rn_sum.^2));

% NB NB NB NB NB : Originally I rotated each target. But now I am only rotating the seeds.
for i = 1:size(n_sum,2)
	% Get a seed rois
	nseed=n_sum(:,i);
	dseed=d_sum(i);
	%seed=rois(:,i);
	% Get a seed random rois
	rnseed=rn_sum(:,i);
	rdseed=rd_sum(i);
	%rseed=rrois(:,i);
	
	% get their rotations and store in a matrix
	% NB NB NB I removed the target from this matrix. Perhaps now the get angle part needs to be adjusted too.
	
	nto_be_cor=[nseed nseed(angles(:,2)) nseed(angles(:,3)) nseed(angles(:,4)) nseed(angles(:,5)) nseed(angles(:,6)) nseed(angles(:,7)) nseed(angles(:,8)) nseed(angles(:,9)) nseed(angles(:,10)) nseed(angles(:,11)) nseed(angles(:,12)) nseed(angles(:,13)) nseed(angles(:,14)) nseed(angles(:,15)) nseed(angles(:,16)) nseed(angles(:,17)) nseed(angles(:,18)) nseed(angles(:,19)) nseed(angles(:,20)) nseed(angles(:,21)) nseed(angles(:,22)) nseed(angles(:,23)) nseed(angles(:,24)) nseed(angles(:,25))];
	
	rnto_be_cor=[rnseed rnseed(angles(:,2)) rnseed(angles(:,3)) rnseed(angles(:,4)) rnseed(angles(:,5)) rnseed(angles(:,6)) rnseed(angles(:,7)) rnseed(angles(:,8)) rnseed(angles(:,9)) rnseed(angles(:,10)) rnseed(angles(:,11)) rnseed(angles(:,12)) rnseed(angles(:,13)) rnseed(angles(:,14)) rnseed(angles(:,15)) rnseed(angles(:,16)) rnseed(angles(:,17)) rnseed(angles(:,18)) rnseed(angles(:,19)) rnseed(angles(:,20)) rnseed(angles(:,21)) rnseed(angles(:,22)) rnseed(angles(:,23)) rnseed(angles(:,24)) rnseed(angles(:,25))];
	
	%tic
	%don't correlate with itself
	for j = (i+1):size(n_sum,2)
		% Get a target rois
		%target=rois(:,j);
		ntarget=n_sum(:,j);
		dtarget=d_sum(j);
		%to_be_cor=[to_be_cor(:,1) rois(:,j) to_be_cor(:,2:end)];
		
		% Get a random target rois
		rntarget=rn_sum(:,j);
		rdtarget=rd_sum(j);
		%rto_be_cor=[rto_be_cor(:,1) rrois(:,j) rto_be_cor(:,2:end)];

		% Calculate all correlations --> take produkt of nseed and ntarget and sum over the rows, divide by the product of dseed and dtarget
		tr= sum(nto_be_cor .* (ntarget*ones(1,size(nto_be_cor,2))) )./( (dseed * dtarget)*ones(1,size(nto_be_cor,2)) );

		rtr= sum(rnto_be_cor .* (rntarget*ones(1,size(rnto_be_cor,2))) )./( (rdseed * rdtarget)*ones(1,size(rnto_be_cor,2)));
	
		% Calculate all correlations: Original
		%tr=corrcoef(to_be_cor);
		% Calculate all correlations: Random
		%rtr=corrcoef(rto_be_cor);
		
		% Get the maximum correlation: Original
		[m, mi]=max(tr);
		%[m, mi]=max(tr(1,2:end));
		% Get the maximum correlation: Random
		[rm, rmi]=max(rtr);
		%[rm, rmi]=max(rtr(1,2:end));
		
		% Maximizing degree: Original
		%mi=mi+1;
		% Maximizing degree: Random
		%rmi=rmi+1;
		
		% Store the correlation: Original
		corr(i,j)=m;
		% Store the correlation: Random
		rcorr(i,j)=rm;
		
		% Store the maximzing degree: Original
		%rot_angle(i, j)=mi;
		% Store the maximzing degree: Random
		%rot_rangle(i, j)=rmi;

	end
end

% Save only necessary variables in temp directory --> for memory issues
% clear the rest and load all of them
t=corr';
rotcorr=t+corr;

temprcorr=rcorr';
rrcorr=temprcorr+rcorr;