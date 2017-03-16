%testTransform.m

clc
clear all
close all


%% Headform Calibration Points

%Raw
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

hcp


%Translate to point 1
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

%% Angle of x axis with horizontal (Below horizontal -ive)
y1Diff=hcp(3,2)-hcp(1,2)
x1Diff=hcp(3,1)-hcp(1,1)
theta1=atan2(y1Diff,x1Diff)

%% Rotate coords counterclockwise by theta1
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

% %Position vector of centroid is prime(:,2)
% prime(:,2)
% %Express as % of 1-3 distance
% primePercentX=prime(1,2)/d1;
% primePercentY=prime(2,2)/d1;
% 
% % 
% % 
% % 
% %% Target Points
% 
% %Raw
%   TP(1,1:2)	=[528.5, 247.0];
%   TP(2,1:2)	=[507.0, 147.2];
%   TP(3,1:2)	=[426.0, 140.5];
%   TP(4,1:2)	=[352.4, 232.3];
%   TP(5,1:2)	=[368.8, 309.2];
%   %TP
%   
%   
%   %Translated to lower left origin
%   TP(:,2)=800-TP(:,2)+1;
%   
%   %Translated to point #5
%   TP(:,1)=TP(:,1)-TP(5,1);
%   TP(:,2)=TP(:,2)-TP(5,2);
%   
%   figure(3)
%   plot(TP(:,1), TP(:,2),'*-r')
%   axis equal
%   
%   
%   %Find -1*angle between 1 and 5
%   y2Diff=TP(1,2)-TP(5,2);
%   x2Diff=TP(1,1)-TP(5,1);
%   theta2=-atan2(y2Diff,x2Diff);
%   d2=sqrt(y2Diff^2 + x2Diff^2)
%   
%   thresh=10;
%   if abs(d1-d2)>thresh
%       disp('***** Calibration Error****')
%   end
%   
%   %Set up rotation matrix
%   rotMat2(1,:) = [ cos(theta2) -sin(theta2)];
%   rotMat2(2,:) = [ sin(theta2)  cos(theta2)];
% 
%   raw2(1,:)=TP(:,1);
%   raw2(2,:)=TP(:,2);
% 
%   %Rotate
%   prime2=rotMat2*raw2
%   
%   figure(4)
%   plot(prime2(1,:), prime2(2,:),'+-b')
%   axis equal
%   hold on
%   
%   %Add the CoM
%   plot(prime(1,2), prime(2,2),'kx')
%   
%   %Add it based on %
%   xPC=d2*primePercentX
%   yPC=d2*primePercentY
%   plot(xPC,yPC,'*r')
%   
%   
  
