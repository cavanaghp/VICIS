clear all
clc

%% Headform Calibration - Virtual Point Generation

handles.calibratedHeadform(1,1:2)=[80.0454  206.2903];
handles.calibratedHeadform(2,1:2)=[190.3173  212.3196];
handles.calibratedHeadform(3,1:2)=[233.5869  138.1065];

%%Set up and plot Raw frame 1 from Demo movie
hcp(1,1:2)=[80.0454  206.2903];
hcp(2,1:2)=[190.3173  212.3196];
hcp(3,1:2)=[233.5869  138.1065];

figure(1)
plot(hcp(:,1),hcp(:,2),'-r')
hold on
plot(hcp(1,1),hcp(1,2),'*-r')
plot(hcp(2,1),hcp(2,2),'*-g')
plot(hcp(3,1),hcp(3,2),'*-b')
axis equal
title('Raw Data')
hcp

%%  Translate to point 1
xtran=hcp(1,1);
ytran=hcp(1,2);
for jk=1:3
    hcp(jk,1)=hcp(jk,1)-xtran;
    hcp(jk,2)=hcp(jk,2)-ytran;   
end
hcp

figure(2)
plot(hcp(:,1),hcp(:,2),'*-b')
axis equal
title('Translated to Point 1')

%%   Angle of x axis with horizontal (below horizontal -ive)
y1Diff=hcp(3,2)-hcp(1,2)
x1Diff=hcp(3,1)-hcp(1,1)
theta1=atan2(y1Diff,x1Diff)

%%  Rotate coorefernce framer counterclockwise by theta1
%See Wolfram http://mathworld.wolfram.com/RotationMatrix.html

rotMat(1,:)= [  cos(theta1) sin(theta1)];
rotMat(2,:)= [ -sin(theta1)  cos(theta1)];

for jk=1:3
    prime(jk,:)=rotMat*[hcp(jk,1) hcp(jk,2)]';
end

prime

figure(3)
X=prime(:,1);
Y=prime(:,2);
plot( X,Y,'+b-')
axis equal
title('Rotated')

%%  Set Position vector of point 2 in Local and translatiom
pV=[1 prime(2,:)]';
tx=hcp(1,1);
ty=hcp(1,2);

%% Procedure for each fram
%  Set up 3 x3 transformation matrix to rotate and translate

theta1=-theta1
T(1,1:3)   =   [1  0                        0];
T(2,1:3)   =   [tx cos(theta1)    -sin(theta1) ]
T(3,1:3)   =   [ty sin(theta1)     cos(theta1) ]

%Find local coordinates
PGlobal = [1 handles.calibratedHeadform(2,1)  handles.calibratedHeadform(2,2) ]'
Plocal  = T * PGlobal
% Where T is transformation from Global to local

%Try the inverse
NewGlobal = inv(T)*pV

%!That works
%   So for every frame:
%   1. Specify new (tx,ty) from Point 3
%   2. Specify new theta from Points 1 and 3
%   3. Predict new global from inverse of above matrix













