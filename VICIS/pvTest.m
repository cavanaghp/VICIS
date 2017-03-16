%PVTest.m
%  
%   Position vector test for VICIS headform CoM calculation
%
clc
clear all
close all

%1. Initialize and plot values from headform calibration frame
handles.calibratedHeadform(1,1:2) =[4,4];
handles.calibratedHeadform(2,1:2) =[2,5];
handles.calibratedHeadform(3,1:2) =[1,1];

figure(1)
plot(handles.calibratedHeadform(:,1),handles.calibratedHeadform(:,2),'x-')
axis equal

%2. Save raw values for verification of transformation matrix
P1=handles.calibratedHeadform(1,:);
P2=handles.calibratedHeadform(2,:);
P3=handles.calibratedHeadform(3,:);

%3. Express all 3 headform calibration points relative to point 3
for jk=1:3
    for jj=1:2
        handles.translatedHeadform(jk,jj)=handles.calibratedHeadform(jk,jj)-handles.calibratedHeadform(3,jj);
    end
end

figure(2)
plot(handles.translatedHeadform(:,1),handles.translatedHeadform(:,2),'-x');

%4.	Find angle between Cartesian X axis and line from origin through point #1
deltaX=  handles.translatedHeadform(1,1);
deltaY=  handles.translatedHeadform(1,2);
theta1= atan2(deltaY,deltaX);
thetaDegrees=57.3*theta1

%5. Rotate translated coordinates by -theta1
%   Transformation is:
%             x' = X*cos(theta) - Y*sin(theta)
%             y' = X*sin(theta) + Y*cos(theta)

rot=-theta1;
rotMat(1,:)= [ cos(rot) -sin(rot)];
rotMat(2,:)= [ sin(rot)  cos(rot)];
rotMat


point_2(1,1)=handles.translatedHeadform(2,1); %X coordinate
point_2(2,1)=handles.translatedHeadform(2,2); %Y coordinate
% 
p=rotMat*point_2
     
% figure(3)
% plot(p(1,:),p(2,:),'xb-')
% axis equal
     
 

%   Set up 4x4 to get pv is one step
T(1,1:4) = [1 0 0 0];
%Set up tramsformation for translation followed by rotation 
% See
% https://www.cs.mtu.edu/~shene/COURSES/cs3621/NOTES/geometry/geo-tran.html
T(1:4,1) = [1 -P3(1)*cos(rot)+P3(2)*sin(rot) -P3(1)*sin(rot)-P3(2)*cos(rot) 0];

%Add rotation matrix
T(2,2:4)=[ rotMat(1,1) rotMat(1,2) 0];
T(3,2:4)=[ rotMat(2,1) rotMat(2,2) 0];
T(4,2:4)=[ 0 0 1 ];

% T(2,2:4)=[ 1 0 0];
% T(3,2:4)=[ 0 1 0];
% T(4,2:4)=[ 0 0 1];
T
point=[ 1 2 5 0]'

newPoint=T*point

%
% set up the x=T*x'
%
T2(1:4,1)=[1 P3(1) P3(2) 0]
T2(2,2:4)=[cos(rot)     sin(rot) 0];
T2(3,2:4)=[-sin(rot)    cos(rot) 0];
T2(4,2:4)=[0 0 1];
T2

%Invert it
T3=inv(T2)


point=[ 1 2 5 0]'

newPoint3=T3*point


newTheta=theta1;
h=-1;
k=-1;

Matrix(1,1:3)=[1 0 0];
Matrix(2,1:3)=[h  cos(newTheta)  sin(newTheta) ];
Matrix(3,1:3)=[k -sin(newTheta)  cos(newTheta) ];

Matrix

ptGlobal=Matrix*[1 3.53 2.1]'

