clc
clear all
close all
% 
handles.calibratedHeadform(1,:)=	[80.4479  207.4847];
handles.calibratedHeadform(2,:)=	[191.0063 213.7975];
handles.calibratedHeadform(3,:)=	[234.7005 139.2273];

figure(1)
subplot(1,3,1)
plot(handles.calibratedHeadform(:,1),handles.calibratedHeadform(:,2),'-x')
axis equal
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)
title('Raw')

%%Translate all points to P1
% P2=P2-P1
% P3=P3-P1
% P1=P1-P1

handles.calibratedHeadform(2,:)=handles.calibratedHeadform(2,:)-handles.calibratedHeadform(1,:);
handles.calibratedHeadform(3,:)=handles.calibratedHeadform(3,:)-handles.calibratedHeadform(1,:);
handles.calibratedHeadform(1,:)=handles.calibratedHeadform(1,:)-handles.calibratedHeadform(1,:);



figure(1)
subplot(1,3,2)
plot(handles.calibratedHeadform(:,1),handles.calibratedHeadform(:,2),'-x')
axis equal
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)
title('Translated')


deltaX=handles.calibratedHeadform(3,1)-handles.calibratedHeadform(1,1);
deltaY=handles.calibratedHeadform(3,2)-handles.calibratedHeadform(1,2);

phi=atan(deltaY/deltaX);
% 
matrix(1,1:2)=[ cos(phi) sin(phi)];
matrix(2,1:2)=[-sin(phi) cos(phi)];
% 
P1=handles.calibratedHeadform(1,:)';
P2=handles.calibratedHeadform(2,:)';
P3=handles.calibratedHeadform(3,:)';

P1prime=matrix*P1;
P2prime=matrix*P2;
P3prime=matrix*P3;
% 
subplot(1,3,3)
plot([P1prime(1) P2prime(1) P3prime(1)],[P1prime(2) P2prime(2) P3prime(2)],'x-');
axis equal
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)
title('Translated & Rotated')

posnVec=P2prime;


%% Simulate impact frame
jk=1;

handles.calibratedHeadform(1,:)=	[80.4479  207.4847];
handles.calibratedHeadform(2,:)=	[191.0063 213.7975];
handles.calibratedHeadform(3,:)=	[234.7005 139.2273];

handles.calibratedImpact(5,jk,:)=handles.calibratedHeadform(3,:)+30;
handles.calibratedImpact(6,jk,:)=handles.calibratedHeadform(1,:)+30;

figure(2)
subplot(1,3,1)
plot([0 posnVec(1)],[0 posnVec(2)],'-x')
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)
title('Pv local')
axis equal

deltaX=handles.calibratedImpact(5,jk,1)-handles.calibratedImpact(6,jk,1);
deltaY=handles.calibratedImpact(5,jk,2)-handles.calibratedImpact(6,jk,2);
impactAngle=atan(deltaY/deltaX);


%% First rotate the position vector by -impact angle
impactAngle=-impactAngle;
matrix(1,1:2)=[ cos(impactAngle) sin(impactAngle)];
matrix(2,1:2)=[-sin(impactAngle) cos(impactAngle)];

pvRot=matrix*posnVec;

figure(2)
subplot(1,3,2)
plot([0 pvRot(1)],[0 pvRot(2)],'-x')
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)
title('Pv rotated')
axis equal

%% Now translate the rotated Pv
pvRotTrans(1)=pvRot(1)+handles.calibratedImpact(6,jk,1);
pvRotTrans(2)=pvRot(2)+handles.calibratedImpact(6,jk,2);

figure(2)
subplot(1,3,3)
plot([0 pvRotTrans(1)],[0 pvRotTrans(2)],'-x')
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)
title('Pv rotated and translated')
axis equal

%Add the original known points
pt5(1:2)=handles.calibratedImpact(5,jk,1:2);
pt6(1:2)=handles.calibratedImpact(6,jk,1:2);
pt7(1:2)=pvRotTrans;
plot([pt5(1) pt6(1) pt7(1) pt5(1)],[pt5(2) pt6(2) pt7(2) pt5(2)],'-g')



