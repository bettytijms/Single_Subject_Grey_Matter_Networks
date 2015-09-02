function [th, fp, sp] = auto_threshold(rotcorr, rrcorr, nz)

maxcor=nz*(nz-1);	
loop_step=[0.1 0.01 0.001 0.0001];

new_start=0.1;	
new_end=1;
c=1;

for j=1:length(loop_step)
	% Smaller steps around 0.5 --> 0.1
	tempi=zeros(length(new_start:loop_step(j):new_end),2);
	for i=new_start:loop_step(j):new_end
		%bin=rrcorr;
		%bin(bin<=i)=0;
		%bin(bin>i)=1;
		%bin_all_degree=sum(bin);
		%sb=sum(bin_all_degree);
		tempi(c,2)=sum(rrcorr(:)>i)/maxcor*100;
		tempi(c,1)=i;
		c=c+1;
	end
	
	% Smaller steps around 0.5 --> 0.01
	t=ones(length(tempi(:,2)),1).*5;
	d=tempi(:,2)-t;

	[id jd]=min(d(d>=0));
	new_start=tempi(jd,1);

	[mid mjd]=max(d(d<0));
	new_end=tempi(mjd+length(d(d>=0)),1);
	c=1;
end

th=new_start;
fp=tempi(jd,2);
sp= sum(rotcorr(:)>th)/maxcor*100;
