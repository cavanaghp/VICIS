function [err,t1Filt,t2Filt,t1Dot,t2Dot,t1DoubleDot,t2DoubleDot]=angleCalc(dataSet,fFreq,sFreq)

%%  Angle Calculations and Plots
     
%Step 1. Express point c2 relative to point c4 for helmet angle
%        and     point c1 relative to point c5 for headform angle

%X,Y of point 2 wrt 4 for helmet    
	X1=dataSet(2,:,1)-dataSet(4,:,1);
	Y1=dataSet(2,:,2)-dataSet(4,:,2);
    t1=atan2(Y1,X1)*57.3; 

%X,Y of point 6 wrt 5 for headform          
    X2=dataSet(6,:,1)-dataSet(5,:,1);
    Y2=dataSet(6,:,2)-dataSet(5,:,2);
    t2=atan2(Y2,X2)*57.3;        

%Express angles relative to zero at first frame
    t1=t1-t1(1);
    t2=t2-t2(1); 

%Apply 4th Order Low Pass Butterworth Filter to Angles
    n=4; %4th order
    fc=fFreq;
    fs=sFreq;
    Wn = 2*fc/fs;
    [b,a] = butter(n,Wn);    

    t1Filt  =filtfilt(b,a,t1);
    t2Filt  =filtfilt(b,a,t2);

    %   Calculate Angular Velocities
    deltaT=1/sFreq;
    t1Dot=1/57.3*(diff(t1Filt)/deltaT);
    t2Dot=1/57.3*(diff(t2Filt)/deltaT);

    %   Calculate Angular Accelerations
    t1DoubleDot  =diff(t1Dot)/deltaT;
    t2DoubleDot  =diff(t2Dot)/deltaT; 
                             
    err=0;

    %%  Update handles structure
    guidata(hObject, handles);
    
end
                             
