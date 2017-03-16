%
%   vTracker.m
%
%   Reflective marker tracker for VICIS
%
%---------------------------------------
%   PRC 01.06.15
%---------------------------------------
    clc
    clear all
    close all
%
%% Reference frame
%
%   ...........X: 1->1152
%   .
%   .
%   .
%   .
%   v
%   Y: 1->720

%% Change log
%
%% Specify video file and create video object
	fileName='/Users/cavanagh/Documents/VICIS/Videos/Ridell.mp4';
    vidObj=VideoReader(fileName)
    
%%  Read a video frame
    %inc=0;
    %while hasFrame(vidObj)
        %inc=inc+1;
        video = readFrame(vidObj);
        frame=rgb2gray(video);
        figure(1)
        imshow(frame)      
    %end
    title('Choose Region of interest for this marker (Top left - bottom right)')
   
%   Choose ROI
	[x,y]=ginput(2);
    x=fix(x)
    y=fix(y)
    
%Overwrite frame outside of ROI with black
%   Top
    for jk=1:y(1)
        frame(jk,:)=0;
    end
    figure(1)
    cla reset
    imshow(frame) 

%Left side of ROI
    for jk=y(1)+1:y(2)
        frame(jk,1:x(1))=0;
    end
    figure(1)
    cla reset
    imshow(frame) 
    
%Right side of ROI
    for jk=y(1)+1:y(2)
        frame(jk,x(2):vidObj.Width)=0;
    end

    
 %Underneath ROI
     for jk=y(2)+1:vidObj.Height
        frame(jk,:)=0;
    end
    figure(1)
    cla reset
    imshow(frame) 
    
    
    title('Point to the marker')
    [mWide,mTall]=ginput(1);
        mWide=fix(mWide)
        mTall=fix(mTall)
        
    %Region grow the area with a maximum differnce of deltaThresh
    deltaThresh=0.2;
    dFrame=im2double(frame);
    J = regiongrowing(dFrame,mTall,mWide,deltaThresh) ;
    
    
    %Show results
    figure(3)
    imshow(J)
    hold on
    
    %Find mean of all identified pixels i.e with value >1
    xAccum=0;
    yAccum=0;
    kount=0;
    for jy=1:size(J,1)
        for jx=1:size(J,2)
            if J(jy,jx)>0
                xAccum=xAccum+jx;
                yAccum=yAccum+jy;
                kount=kount+1;
            end
        end
    end
        
    meanX=xAccum/kount
    meanY=yAccum/kount
    
    plot(meanX, meanY,'*r')