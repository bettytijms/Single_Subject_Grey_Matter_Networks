function a= rotation_xyz(dim,forty)
% Takes the dimensions of a cube as argument and returns the array a which contains the indices to rotate a cube of that dimension.

%% Rotate over the X axis
X90=[];
for i=dim:-1:1
	for t=0:(dim-1)
		X90=[X90, i+t*dim^2];
	end

	% Use i as starting value for next loop
	y=i;
	for j=1:(dim-1)
		y=i+j*dim;
		for t=0:(dim-1)
			X90=[X90, y+t*dim^2];
		end
	end
end

X180=X90(X90);
X270=X180(X90);

% add X rotation 3 * 45 degrees
X45 = [2,3,12,5,6,15,8,9,18,1,11,21,4,14,24,7,17,27,10,19,20,13,22,23,16,25,26];
X135= X45(X90);
X225= X135(X90);
X315 = X225(X90);


% test whether ok:
%X360=X270(X90);
%all(X360(:)==cube(:))

%% Y rotation

Y90=[];
for i=0:(dim-1)
	y=dim^2*(dim-1)+1+i*dim;

	%Loop through other dimensions	
	for t=0:dim-1
		Y90=[Y90 (y-t*dim^2):(y-t*dim^2+dim-1)];
	end
end	

Y180=Y90(Y90);
Y270=Y180(Y90);

% Test if correct
%Y360=Y270(Y90);
%all(Y360(:)==Y360(:))

% Y rotation in 3*45 degrees
Y45 = [10,11,12,1,2,3,4,5,6,19,20,21,13,14,15,7,8,9,22,23,24,25,26,27,16,17,18];
Y135=Y45(Y90);
Y225=Y135(Y90);
Y315=Y225(Y90);

%% Z Rotation

Z90=[];
for i=dim:dim^2:dim^3
	% loop through other dimensions
	for t=0:dim-1
		Z90=[Z90, i+t*dim];
	end
	
	% Loop through other dimensions
	for j=i-1:-1:(i-dim+1)
	
		for t=0:dim-1
			Z90=[Z90, j+t*dim];
		end

	end
end

Z180=Z90(Z90);
Z270=Z180(Z90);

% test whether ok:
%Z360=Z270(Z90);
%all(Z360(:)==cube(:))

% Z rotation 3* 45 degrees
Z45= [2,3,6,1,5,9,4,7,8,11,12,15,10,14,18,13,16,17,20,21,24,19,23,27,22,25,26];
Z135= Z45(Z90);
Z225= Z135(Z90);
Z315= Z225(Z90);

%% Reflection over X axis
cube=1:dim^3;
cube=reshape(cube,dim,dim,dim);

Xref=[];
for i=1:dim
	t=flipud(cube(:,:,i));
	Xref=[Xref, reshape(t,1,dim^2)]; 
end

%% Reflect over Y axis
Yref=[];
for i=1:dim
	t=fliplr(cube(:,:,i));
	Yref=[Yref, reshape(t,1,dim^2)]; 
end

%% Reflect over Z axis
Zref=[];
for i=dim:-1:1
	Zref=[Zref, reshape(cube(:,:,i),1,dim^2)]; 
end

if forty==1
	a=[[1:dim^3]',Y90',Y180',Y270',X90',X180',X270',Z90',Z180',Z270',Yref',Xref',Zref'];
elseif forty == 2
	a=[[1:3^3]',Y45', Y90',Y135', Y180',Y225',Y270',Y315',X45', X90',X135', X180',X225',X270',X315',Z45', Z90',Z135', Z180',Z225',Z270',Z315',Yref',Xref',Zref'];
end