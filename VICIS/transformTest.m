clear all
clc

%%  Find Position vector of point 2
%Calculate rotation in headfrom calibration frame
%Clockwise +-ve
handles.calibratedHeadform(1,1:2) =[4,4];
handles.calibratedHeadform(2,1:2) =[2,5];
handles.calibratedHeadform(3,1:2) =[1,1];

Pt1=handles.calibratedHeadform(1,:);
Pt3=handles.calibratedHeadform(3,:);

deltaY= Pt1(2)-Pt3(2)
deltaX= Pt1(1)-Pt3(1)
Theta =atan2(deltaY,deltaX)

%Calculate translation required
tx=-Pt3(1)
ty=-Pt3(2)

%Set up 3 x3 transformation matrix to rotate and translate
Theta=-Theta
T(1,1:3)   =   [1  0                        0];
T(2,1:3)   =   [-tx cos(Theta)    -sin(Theta) ]
T(3,1:3)   =   [-ty sin(Theta)     cos(Theta) ]

%Find local coordinates
PGlobal = [1 handles.calibratedHeadform(2,1)  handles.calibratedHeadform(2,2) ]'
Plocal  = T * PGlobal
% Where T is transformation from Global to local

%Try the inverse
NewGlobal = inv(T)*Plocal

%!That works
%   So for every frame:
%   1. Specify new (tx,ty) from Point 3
%   2. Specify new theta from Points 1 and 3
%   3. Predict new global from inverse of above matrix













