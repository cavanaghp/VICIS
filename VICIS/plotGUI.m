%
%   plotGUI for vTracker - VICIS Motion Tracker
%
%
%   Peter R. Cavanagh 03.16.17v2
%

%   #1  varargout
%   #2  plotGUI_OpeningFcn
%   #3  

%   #1 varargout
function varargout = plotGUI(varargin)
% PLOTGUI MATLAB code for plotGUI.fig
%      PLOTGUI, by itself, creates a new PLOTGUI or raises the existing
%      singleton*.
%
%      H = PLOTGUI returns the handle to a new PLOTGUI or the handle to
%      the existing singleton*.
%
%      PLOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTGUI.M with the given input arguments.
%
%      PLOTGUI('Property','Value',...) creates a new PLOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotGUI

% Last Modified by GUIDE v2.5 16-Mar-2017 11:27:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @plotGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

%   #2 plotGUI_OpeningFcn
% --- Executes just before plotGUI is made visible.
function plotGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotGUI (see VARARGIN)

% Choose default command line output for plotGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

    %% 1. Adjust Fontsize on all buttons
    
    %% 2. Show logo
	axes(handles.axes1)
    cla reset   
    set(handles.axes1,'visible','on') 
	imshow('VICIS_logo.png')
    
    %% 3. Set Visibility
    %set(handles.playVideo1, 'visible','off')
    %set(handles.pauseVideo1,'visible','off')
    
    %% 4. Set initial values
    set(handles.pauseVideo1,'value',0)
    set(handles.pauseVideo2,'value',0)
    set(handles.pauseVideo3,'value',0)
  
    %% 5. Deal with file 1
    
    %Get Arguments from vTracker GUI
    handles.numFiles                =getappdata(0,'numFiles');
    handles.fontSize                =getappdata(0,'fontSize');
    handles.impactDataFile1         =getappdata(0,'calibratedImpact');
    handles.headformDataFile1       =getappdata(0,'calibratedHeadform');
    handles.filterFrequencyFile1    =getappdata(0,'filterFrequency');
    handles.sampleFrequencyFile1    =getappdata(0,'sampleFrequency'); 
    handles.deltaTFile1             =1/handles.sampleFrequencyFile1;
    handles.videoLongNameFile1      =getappdata(0,'longFilename');
    handles.inFrameNumberFile1      =getappdata(0,'inFrame');
    handles.outFrameNumberFile1     =getappdata(0,'outFrame');
    handles.compressionBaselineFile1=getappdata(0,'baseline');
       
    %% 6. Extract short name for video file1
    % 6.1 Find string length
    nameLen=size(handles.videoLongNameFile1,2);
    
    %6.2 Locate slashes
    if ispc
        place=strfind(handles.videoLongNameFile1,'\')
    else
        place=strfind(handles.videoLongNameFile1,'/')
    end
    
    %6.3 Extract the short name
    numSlashes=size(place,2)
    ss1=place(numSlashes)+1
    ss2=nameLen
    handles.videoShortNameFile1=handles.videoLongNameFile1(ss1:ss2)
    
    %6.4 Post short name
    set(handles.file1Title,'string',handles.videoShortNameFile1);
    
    %6.5 Construct Video Object for file 1
    h = waitbar(0,'Parsing video file #1...');
    inc=1;
    try
        vidObj1=VideoReader(handles.videoLongNameFile1);
        while hasFrame(vidObj1)
            inc=inc+1;    
            %Read RGB Frame
            video = readFrame(vidObj1);
            %Convert to gray scale
            gray  = rgb2gray(video);
            %Save in frame array
            handles.grayFrame(inc,:,:)=gray(:,:);
            waitbar(inc/200,h)
        end;
        close(h)
    catch
        lines{1}='Video file not available';
        lines{2}=handles.vvideoLongNameFile1;
        set(handles.promptBox,'string',lines)
    end
    
    %6.6    Show inFrame and post frame number
    % Show
    axes(handles.video1)
    cla reset
    showFrame(:,:)=handles.grayFrame(handles.inFrameNumberFile1,:,:);
    imshow(showFrame);
    hold on  
    %Post
    set(handles.file1FrameNumber,'string',num2str(handles.inFrameNumberFile1))
    handles.nowFrame1=handles.inFrameNumberFile1;
  
    %%  Generate Time arrays for file1plots in ms
   
    n1=handles.outFrameNumberFile1-handles.inFrameNumberFile1+1;
    n2=n1-1;
    n3=n1-2;
    
    for jk=1:n1
      handles.time1File1(jk)=(jk-1)*1000*handles.deltaTFile1;
    end
    
    for jk=1:n2
      handles.time2File1(jk) =(jk-1)*1000*handles.deltaTFile1+handles.deltaTFile1/2;
    end  
    
    for jk=1:n3
      handles.time3File1(jk) =jk*1000*handles.deltaTFile1;
    end
                            
    %% 7. Get other files if needed
    numFiles= handles.numFiles;
    
    switch numFiles
        case 2
            lines{1}='Browse to compare datafile';
            set(handles.promptBox,'string',lines)
            [dataFile2Name,dataFile2Path]=uigetfile('*.*');
            longName=strcat(dataFile2Path,dataFile2Name)
           
            %Open the file
            fid=fopen(longName);
        
            %Read the video long file name
            handles.videoFile2LongName=fgetl(fid);
            
            %Read info line
            tline1 = fgetl(fid);
            v1=strread(tline1);
                handles.numMarkers=v1(1);
                handles.framesToAnalyze2=v1(2);
                handles.compressionBaseline2=v1(3);
                handles.sampleFrequency2=v1(4);
                handles.filterFrequency2=v1(5);
                handles.scaleFactor2=v1(6);
                handles.inFrameNumber=v1(7);
                handles.outFrameNumber=v1(8);

                %Read headform X then Y coordinates
                tline2 = fgetl(fid);
                v2=strread(tline2);
                    handles.calibratedHeadform(1,1)=v2(1);
                    handles.calibratedHeadform(2,1)=v2(2);
                    handles.calibratedHeadform(3,1)=v2(3);
                    handles.calibratedHeadform(1,2)=v2(4);
                    handles.calibratedHeadform(2,2)=v2(5);
                    handles.calibratedHeadform(3,2)=v2(6);
        
                %Read the X coordinates of the impact data
                for jk=1:handles.framesToAnalyze;
                    tline3 = fgetl(fid);
                    handles.file2Data(1:6,jk,1)=strread(tline3);
                end

                %Read the Y coordinates of the impact data
                for jk=1:handles.framesToAnalyze;
                       tline3 = fgetl(fid);
                       handles.file2Data(1:6,jk,2)=strread(tline3);
                end 
                disp(done)
           
           %% Extract short name for video file2
            %   Find string length
            nameLen=size(handles.videoLongNameFile2,2);
            %   Locate slashes
            if ispc
                place=strfind(handles.videoFile2LongName,'\')
            else
                place=strfind(handles.videoFile2LongName,'/')
            end
            %   Extract the short name
            numSlashes=size(place,2)
            ss1=place(numSlashes)+1
            ss2=nameLen
            handles.videoShortNameFile2=handles.videoLongNameFile2(ss1:ss2)
            %   Post it
            set(handles.file2Title,'string',handles.videoShortNameFile2);

            
          
        case 3
            lines{1}='Browse to compare file #1';
            set(handles.promptBox,'string',lines)
            [videoFile2Name,videoFile2Path]=uigetfile('*.*');
            handles.videoFile2LongName=strcat(videoFile2Path,videoFile2Name);
          
    end
   
%%  Update handles structure
    guidata(hObject, handles);
        
    
end
        
%   #3 plotGUI_OutputFcn
% --- Outputs from this function are returned to the command line.
function varargout = plotGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in plotOptionsPopUp.
function plotOptionsPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to plotOptionsPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotOptionsPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotOptionsPopUp
    
    plotChoice=get(handles.plotOptionsPopUp,'value');
    
    handles.deltaT=1/handles.sampleFrequencyFile1;
    
    switch plotChoice
        case 2
            %% Angles
                numFiles=handles.numFiles;
                switch numFiles 
                    case 1
                        % Single plot of current data
                        %Call angleCalc
                        [err,t1,t2,t1Dot,t2Dot,t1DoubleDot,t2DoubleDot]=angleCalc(handles.impactDataFile1, ...
                        handles.filterFrequencyFile1,handles.sampleFrequencyFile1, ...
                        handles.dataPlot11,handles.dataPlot12,handles.dataPlot13, ...
                        handles.time1File1,handles.time2File1,handles.time3File1);

                        %Save results
                        handles.smoothedHelmetAngleFile1=t1;
                        handles.smoothedHeadformAngleFile1=t2;
                        handles.helmetOmegaFile1=t1Dot;
                        handles.headformOmegaFile1=t2Dot;
                        handles.helmetOmegaDotFile1=t1DoubleDot;
                        handles.headformOmegaDotFile1=t2DoubleDot;

 
      
                    case 2
                        % Compare with 1 files
                        
                    case 3
                        % Compare with 2 files
                end
            
        case 3
            %% Headform CoM
                numFiles=handles.numFiles;
                switch numFiles 
                    case 1
                        %[handles.CoMFile1,handles.CoMVelFile1,handles.CoMAccnFile1]= ...
                        [headformCoMFile1,headformVelFiles1,headformAccnFile1]=centerOfMassCalc(handles.impactDataFile1 ,handles.headformDataFile1, ...
                            handles.sampleFrequencyFile1,handles.filterFrequencyFile1, ...
                            handles.dataPlot11,handles.dataPlot12,handles.dataPlot13, ...
                            handles.time1File1,handles.time2File1,handles.time3File1);  
                    case 2
                        % Compare with 1 files
                    case 3
                        % Compare with 2 files
                end           
        case 4
            %% Compression
                numFiles=handles.numFiles;
                switch numFiles 
                    case 1
                      [handles.compressionFile1,handles.compressionRateFile1]= ...
                      compressionCalc(handles.impactDataFile1,handles.compressionBaselineFile1,handles.filterFrequencyFile1,handles.sampleFrequencyFile1)
                        
                      axes(handles.dataPlot13) 
                      cla reset
                      set(handles.dataPlot13,'visible','off')

                      axes(handles.dataPlot12) 
                      cla reset
                      set(handles.dataPlot12,'visible','off')
                      
                      axes(handles.dataPlot11) 
                      cla reset
                      set(handles.dataPlot11,'visible','on')
                               
                      [hAx,hLine1,hLine2]=plotyy(handles.time1File1,handles.compressionFile1,handles.time2File1,handles.compressionRateFile1);
                      hold on

                      ylabel(hAx(1),'Compression (mm)') 
                      ylabel(hAx(2),'Compression Rate (mm/s)')
                      xlabel('Time (ms)')
                      title('Compression and Compression Rate')
                      plot([handles.time1File1(1) handles.time1File1(size(handles.time1File1,2))],[0 0],'r-')
      
                    case 2
                        % Compare with 1 files
                    case 3
                        % Compare with 2 files
                end      
    end
end

% --- Executes during object creation, after setting all properties.
function plotOptionsPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotOptionsPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in playVideo1.
function playVideo1_Callback(hObject, eventdata, handles)
% hObject    handle to playVideo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     
     axes(handles.video1)
     cla reset
     set(handles.pauseVideo1,'visible','on')
     set(handles.video1,'visible','on')
     
     %% Show each frame unless interrupted by pause
     disp(['Started at Frame #',num2str(handles.nowFrame1)])
     for jk=handles.nowFrame1+1:handles.outFrameNumberFile1

            set(handles.file1FrameNumber,'string',num2str(jk))
            pause(.01)
            cla reset
            showFrame(:,:)=handles.grayFrame(jk,:,:);
            imshow(showFrame);
            if (get(handles.pauseVideo1,'value'))==1
                %Pause Button was pressed
                handles.nowFrame1=jk;
                
                %Turn off pause Button so it can be used again
                set(handles.pauseVideo1,'value',0)
                
                % Update handles structure
                guidata(hObject, handles);
                disp(['Paused at Frame #',num2str(handles.nowFrame1)])
                break
            end
     end
     if handles.nowFrame1==handles.outFrameNumberFile1
        handles.nowFrame1=handles.inFrameNumberFile1;
     end
     
     disp(['Normal end: Frame #',num2str(handles.nowFrame1)])
     
%%  Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in pauseVideo1.
function pauseVideo1_Callback(hObject, eventdata, handles)
% hObject    handle to pauseVideo1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseVideo1
end

% --- Executes on button press in playVideo2.
function playVideo2_Callback(hObject, eventdata, handles)
% hObject    handle to playVideo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in playVideo3.
function playVideo3_Callback(hObject, eventdata, handles)
% hObject    handle to playVideo3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pauseVideo2.
function pauseVideo2_Callback(hObject, eventdata, handles)
% hObject    handle to pauseVideo2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseVideo2
end

% --- Executes on button press in pauseVideo3.
function pauseVideo3_Callback(hObject, eventdata, handles)
% hObject    handle to pauseVideo3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pauseVideo3
end

function showVideo(fileName,inFrame,outFrame,axisNow)

%% Read all frames of video
    
    inc=0;
    
    h = waitbar(0,'Parsing video file...');
    %Assume there are 200 frames for waitbar
    
    %% VideoReader Creates a multimedia reader object containing all frames. 
    myVideoObj=VideoReader(fileName);
    while hasFrame(myVideoObj)
        inc=inc+1;    
        %Read RGB Frame
        frame = readFrame(myVideoObj);
        
        %Convert to gray scale
        gray  = rgb2gray(frame);
        
        %Save in greyFrame array
        handles.grayFrame(inc,:,:)=gray(:,:);
        waitbar(inc/200,h)
    end
    
    %Show nFrame in axes 1
    axes(axisNow)
    cla reset
    showFrame(:,:)=handles.grayFrame(inFrame,:,:);
    imshow(showFrame);
    hold on
    
    set(handles.playVideo1,'visible','on')
    handles.nowFrame=1;
    
    
    %%  Update handles structure
    guidata(hObject, handles);
    
end

function [err,helmetAngle,headformAngle,helmetAngleDot,headformAngleDot,helmetAngleDoubleDot,headformAngleDoubleDot] ...
         =angleCalc(dataSet,fFreq,sFreq,axisID1,axisID2,axisID3, ...
         time1,time2,time3)

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
    helmetAngle  =t1-t1(1);
    headformAngle=t2-t2(1); 

%Apply 4th Order Low Pass Butterworth Filter to Angles
    n=4; %4th order
    fc=fFreq;
    fs=sFreq;
    Wn = 2*fc/fs;
    [b,a] = butter(n,Wn);    

    helmetAngle    =filtfilt(b,a,helmetAngle);
    headformAngle  =filtfilt(b,a,headformAngle);

    %   Calculate Angular Velocities
    deltaT=1/sFreq;
    helmetAngleDot  =1/57.3*(diff(helmetAngle)/deltaT);
    headformAngleDot=1/57.3*(diff(headformAngle)/deltaT);

    %   Calculate Angular Accelerations
    helmetAngleDoubleDot    =diff(helmetAngleDot)/deltaT;
    headformAngleDoubleDot  =diff(headformAngleDot)/deltaT; 
                 
    %%Plot Results
    
    axes(axisID1)
    cla reset
    plot(time1,helmetAngle,'-r')
    hold on
    plot(time1,headformAngle,'-b')
    legend('Helmet','Headform')
    title('Angles')
    xlabel('Time (ms)')
    ylabel('Angle (degrees)')  

    axes(axisID2)
    plot(time2,helmetAngleDot,'-r')
    hold on
    plot(time2,headformAngleDot,'-b')
    legend('Helmet','Headform')      
    title ('Angular Velocities')
    xlabel('Time (ms)')
    ylabel('Angular Velocity (rad/s)')

    axes(axisID3)
    plot(time3,helmetAngleDoubleDot,'-r')
    hold on
    plot(time3,headformAngleDoubleDot,'-b')
    legend('Helmet','Headform')      
    title ('Angular Accelerations')
    xlabel('Time (ms)')
    ylabel('Angular Acceleration (rad/s^2)')  
                        
    err=0;
    
end

function [compression,compressionRate] = compressionCalc(dataIn,baseline,filterFrequency,sampleFrequency)
 
%%    Compression Estimate from Calibrated Markers 1 and 3

      a1(:,1)=dataIn(1,:,1);
      a1(:,2)=dataIn(1,:,2);

      a2(:,1)=dataIn(3,:,1);
      a2(:,2)=dataIn(3,:,2); 
     
      compression=sqrt(  (a1(:,1)-a2(:,1)).^2 + (a1(:,2)-a2(:,2)).^2  );
%         
%     %Express relative to baseline
      compression=compression-baseline;
        
%     %Filter the compression distance
%     Apply 4th Order Low Pass Butterworth Filter to Angles
         n=4; %4th order
         fc=filterFrequency;
         fs=sampleFrequency;
         Wn = 2*fc/fs;
         [b,a] = butter(n,Wn);
         
      compression  =filtfilt(b,a,compression);
% 
%     %Calculate rate of compression
      compressionRate= diff(compression); 
%         
end
         
function[headformCoM,headformCoMVel,headformCoMAccn]=centerOfMassCalc(calibratedImpact,calibratedHeadform, ...
        sampleFrequency,filterFrequency,axisID1,axisID2,axisID3,time1,time2,time3)

%%  Calculate Position Vector of Headform Centroid
    
    %Test plot initial coordinates
    figure(1)
    subplot(1,3,1)
    plot(calibratedHeadform(:,1),calibratedHeadform(:,2),'-x')
    axis equal
    hold on
    plot([0 100],[0 0],'r-','linewidth',2)
    plot([0 0],[0 100],'r-','linewidth',2)
    title('Raw')

    %%Translate all points to P1
    % P2=P2-P1
    % P3=P3-P1
    % P1=P1-P1

    calibratedHeadform(2,:)=calibratedHeadform(2,:)-calibratedHeadform(1,:);
    calibratedHeadform(3,:)=calibratedHeadform(3,:)-calibratedHeadform(1,:);
    calibratedHeadform(1,:)=calibratedHeadform(1,:)-calibratedHeadform(1,:);

    %Test plot translated coordinates
    figure(1)
    subplot(1,3,2)
    plot(calibratedHeadform(:,1),calibratedHeadform(:,2),'-x')
    axis equal
    hold on
    plot([0 100],[0 0],'r-','linewidth',2)
    plot([0 0],[0 100],'r-','linewidth',2)
    title('Translated')

    %Rotate by anglee between pts 1 and 3
    deltaX=calibratedHeadform(3,1)-calibratedHeadform(1,1);
    deltaY=calibratedHeadform(3,2)-calibratedHeadform(1,2);
    phi=atan(deltaY/deltaX);
    % 
    matrix(1,1:2)=[ cos(phi) sin(phi)];
    matrix(2,1:2)=[-sin(phi) cos(phi)];
    % 
    P1=calibratedHeadform(1,:)';
    P2=calibratedHeadform(2,:)';
    P3=calibratedHeadform(3,:)';

    P1prime=matrix*P1;
    P2prime=matrix*P2;
    P3prime=matrix*P3;
    % 
    % Test plot and translated and rotated coordindates
    subplot(1,3,3)
    plot([P1prime(1) P2prime(1) P3prime(1)],[P1prime(2) P2prime(2) P3prime(2)],'x-');
    axis equal
    hold on
    plot([0 100],[0 0],'r-','linewidth',2)
    plot([0 0],[0 100],'r-','linewidth',2)
    title('Translated & Rotated')

    posnVec=P2prime;

    %% Predict location of virtual point on every frame
    numFrames=size(calibratedImpact,2);
    for jk=1:numFrames

        figure(2)
        subplot(1,3,1)
        plot([0 posnVec(1)],[0 posnVec(2)],'-x')
        hold on
        plot([0 100],[0 0],'r-','linewidth',2)
        plot([0 0],[0 100],'r-','linewidth',2)
        title('Pv local')
        axis equal

        deltaX=calibratedImpact(5,jk,1)-calibratedImpact(6,jk,1);
        deltaY=calibratedImpact(5,jk,2)-calibratedImpact(6,jk,2);
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

        %% Now translate the rotated Pv and save as pt 7
        pvRotTrans(1)=pvRot(1)+calibratedImpact(6,jk,1);
        pvRotTrans(2)=pvRot(2)+calibratedImpact(6,jk,2);
        calibratedImpact(7,jk,1:2)=pvRotTrans;
              
        figure(2)
        subplot(1,3,3)
        plot([0 pvRotTrans(1)],[0 pvRotTrans(2)],'-x')
        hold on
        plot([0 100],[0 0],'r-','linewidth',2)
        plot([0 0],[0 100],'r-','linewidth',2)
        title('Pv rotated and translated')
        axis equal

        %Add the original known points
        pt5(1:2)=calibratedImpact(5,jk,1:2);
        pt6(1:2)=calibratedImpact(6,jk,1:2);
        pt7(1:2)=pvRotTrans;
        plot([pt5(1) pt6(1) pt7(1) pt5(1)],[pt5(2) pt6(2) pt7(2) pt5(2)],'-g')

    end
    figure(3)
    for kk=1:numFrames
        X=[calibratedImpact(5,kk,1) calibratedImpact(6,kk,1) calibratedImpact(7,kk,1) calibratedImpact(5,kk,1)];
        Y=[calibratedImpact(5,kk,2) calibratedImpact(6,kk,2) calibratedImpact(7,kk,2) calibratedImpact(5,kk,2)];
        plot(X,Y,'bx-');
        hold on
    end
    
    %% Smooth Headform CoM trajectory (calibratedImpact Point 7)
    for kk=1:numFrames
        headformCOM(kk,:)=calibratedImpact(6,kk,:);
    end
    
    %    Apply 4th Order Low Pass Butterworth Filter to Angles
         n=4; %4th order
         fc=filterFrequency;
         fs=sampleFrequency;
         Wn = 2*fc/fs;
         [b,a] = butter(n,Wn);    
                  
         headformCoM(:,1) =filtfilt(b,a,headformCOM(:,1));
         headformCoM(:,2) =filtfilt(b,a,headformCOM(:,2));
         
         %% Plot smoothed displacment
         axes(axisID1)
         cla reset
         plot(time1,headformCoM(:,1))
         hold on
         plot(time1,headformCoM(:,2)) 
         title('Headform C of M')
         xlabel('Time (ms)')
         ylabel('Displacement (mm)')
         legend('X','Y')
         

         %% Calculate and Plot Headform velocity and acceleration
         headformCoMVel =diff(headformCoM);
         axes(axisID2)
         cla reset
         plot(time2,headformCoMVel(:,1))
         hold on
         plot(time2,headformCoMVel(:,2))
         title('Headform CoM Velocity')
         xlabel('Time (ms)')
         ylabel('Velocity (mm/s)')
         legend('X','Y')
         
         
         headformCoMAccn=diff(headformCoMVel);
         axes(axisID3)
         cla reset
         plot(time3,headformCoMAccn(:,1))
         hold on
         plot(time3,headformCoMAccn(:,2))
         title('Headform CoM Accn')
         xlabel('Time (ms)')
         ylabel('Accn (mm/s^2)')
         legend('X','Y')
         

end


% --- Executes on button press in expand11.
function expand11_Callback(hObject, eventdata, handles)
% hObject    handle to expand11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of expand11

set(handles.dataPlot11,'visible','on')
set(handles.dataPlot12,'visible','off')
set(handles.dataPlot13,'visible','off')
set(handles.dataPlot21,'visible','off')
set(handles.dataPlot22,'visible','off')
set(handles.dataPlot23,'visible','off')
set(handles.dataPlot31,'visible','off')
set(handles.dataPlot32,'visible','off')
set(handles.dataPlot33,'visible','off')

end


