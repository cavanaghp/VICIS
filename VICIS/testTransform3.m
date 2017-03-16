clc
clear all
close all
% 
P1=	[80.4479  207.4847];
P2=	[191.0063 213.7975];
P3=	[234.7005 139.2273];

%%Translate all points to P1
P2=P2-P1
P3=P3-P1
P1=P1-P1

figure(1)
subplot(1,2,1)
plot([P1(1) P2(1) P3(1)],[P1(2) P2(2) P3(2)],'x-')
axis equal
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)
% 
deltaX= P3(1)-P1(1)
deltaY= P3(2)-P1(2)
phi=atan(deltaY/deltaX)

matrix(1,1:2)=[ cos(phi) sin(phi)]
matrix(2,1:2)=[-sin(phi) cos(phi)]

P1prime=matrix*P1'
P2prime=matrix*P2'
P3prime=matrix*P3'

subplot(1,2,2)
plot([P1prime(1) P2prime(1) P3prime(1)],[P1prime(2) P2prime(2) P3prime(2)],'x-')
axis equal
hold on
plot([0 100],[0 0],'r-','linewidth',2)
plot([0 0],[0 100],'r-','linewidth',2)

posnVec=P2prime