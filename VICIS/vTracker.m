%
%   vTracker - VICIS Motion Tracker
%
%   Peter R. Cavanagh 03.10.17
%
%%  Tuning:
%   Movement slider defines a value (0->1) that defines search area for the next frame.
%                   Search area is a square around the prior marker location 
%                   [(1+Movement slider) * marker diameter] pixels in size.
%                   Marker diameter is calculated for each marker, each
%                   frame.
%.................................................................................
%%  Change Log
%
%
%
%%  Requires:
%   regionGrowing.m from 
%   http://www.mathworks.com/matlabcentral/fileexchange/19084-region-growing
%
%%          CONTENTS
%
%   #01 -   vTracker
%   #02 -   vTracker_OutputFcn
%   #03 -   vTracker_OpeningFcn
%   #04 -   settingsButton_Callback
%   #05 -   newDataButton_Callback
%   #06 -   readDataButton_Callback
%   #07 -   browseToVideoDirectory_Callback
%   #08 -   browseToDataDirectory_Callback
%   #09 -   quitButton
%   #10 -   loadHeadformVideo_Callback
%   #11 -   maxMarkerSizePopUp_Callback
%   #12 -   maxMarkerSizePopUp_CreateFcn
%   #13 -   startHeadformAnalysisButton_Callback
%   #14 -   regionGrowing
%   #15 -   restartButton_Callback
%   #16 -   loadTouchVideo_Callback
%   #17 -   startTouchAnalysisButton_Callback
%   #18 -   loadImpactVideo_Callback
%   #19 -   playButton_Callback
%   #20 -   pauseButton_Callback
%   #21 -   backFrameButton_Callback
%   #22 -   forwardFrameButton
%   #23 -   fastBackButton
%   #24 -   fastForwardFrameeButton
%   #25 -   Mark In  
%   #26 -   Mark Out  
%   #27 -   inframedisplay 
%   #28 -   outFramedisplay
%   #29 -   analyzeButton
%   #30 -   startImpactAnalysisButton_Callback
%   #31 -   Movement Slider callback
%   #32 -   Movement Slider creatfcn
%   #33     confirmButton 
%   #34 -   numMarkerspopup_Callback
%   #35 -   numMarkerspopup_CreateFcn
%   #36 -   markerShapePopup_Callback
%   #37 -   markerShapePopup_CreateFcn
%   #38 -   graphButton_Callback
%   #39 -   saveDataButton_Callback
%   #38 -   filterPopup_Callback
%   #39 -   filterPopup_CreateFcn
%   #40 -   sampleFreqPopUp_Callback
%   #41 -   sampleFreqPopUp_CreateFcn
%   #42 -   calLength_callback
%   #43 -   calLength_CreateFcn
%   #44 -   directionPopUp_Callback
%   #45 -   directionPopUp_CreateFcn
%   #46 -   fontSizePopUp_Callback
%   #47 -   fontSizePopUp_CreateFcn
%   #48 -   directionPopUp_Callback
%   #49 -   directionPopUp_CreateFcn



%%  Start of Code

%   #01 - vTracker
function varargout = vTracker(varargin)
% VTRACKER MATLAB code for vTracker.fig
%      VTRACKER, by itself, creates a new VTRACKER or raises the existing
%      singleton*.
%
%      H = VTRACKER returns the handle to a new VTRACKER or the handle to
%      the existing singleton*.
%
%      VTRACKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VTRACKER.M with the given input arguments.
%
%      VTRACKER('Property','Value',...) creates a new VTRACKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vTracker_OpeningFcn gets called.  analyzeButton
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vTracker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vTracker

% Last Modified by GUIDE v2.5 14-Mar-2017 21:02:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vTracker_OpeningFcn, ...
                   'gui_OutputFcn',  @vTracker_OutputFcn, ...
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

%   #02 -   vTracker_OutputFcn
% --- Outputs from this function are returned to the command line.
function varargout = vTracker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%   #03 -   vTracker_OpeningFcn
% --- Executes just before vTracker is made visible.
function vTracker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vTracker (see VARARGIN)

    %% 3.1   Choose default command line output for vTracker
    handles.output = hObject;

    % UIWAIT makes vTracker wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

    %% %User code below..........................................
    
    %% 3.2  Clear the command window and gloabal variables
    clc    
    clear global
    
    %% 3.25 Trap run without QUIT. settingsOpen is the first handles variable declared
    if  isfield(handles,'settingsOpen')
        line{1}='Click QUIT and run the App again';
        set(handles.promptBox,'string',line)
        return       
    end

       
    %% 3.3  Turn warnings off
    %warning('off','all')
   
    %% 3.4  Change the current folder to the folder of this m-file
    %       so that logo will be picked up
    
    cd(fileparts(which('vTracker.m')));

    %% 3.5  Set visibility and initialize values of objects
    
        %% 3.5.1    Objects to show on opening
        
        axes(handles.axes2)
        cla reset   
        set(handles.axes2,'visible','on') 
        imshow('VICIS_logo.png')
        
        buttonImage=imread('Settings_v2.jpg');
        set(handles.settingsButton,'CData',buttonImage)
        set(handles.settingsButton,'visible','on')
      
        set(handles.newDataButton,'visible','on')
        set(handles.readDataButton,'visible','on')
        set(handles.promptBox,'visible','on')
        set (handles.analyzeButton,'visible','on')


        %% 3.5.2    Objects to hide on opening

        set(handles.browseToVideoDirectory,'visible','off')
        set(handles.browseToDataDirectory,'visible','off')
        set(handles.videoDirectoryDisplay,'visible','off')
        set(handles.videoDirectoryLabel,'visible','off')
        set(handles.dataDirectoryDisplay,'visible','off')
        set(handles.dataDirectoryLabel,'visible','off')

        set(handles.loadHeadformVideo,'visible','off')
        set(handles.loadTouchVideo,'visible','off')
        set(handles.loadImpactVideo,'visible','off')

        set(handles.maxMarkerSizePopUp,'visible','off')
        set(handles.maxMarkerSizePopUpLabel,'visible','off')
        set(handles.tuningLabel,'visible','off')

        set(handles.startHeadformAnalysisButton,'visible','off')
        set(handles.startTouchAnalysisButton,'visible','off')
        set(handles.startImpactAnalysisButton,'visible','off')

        set(handles.marker1Label,'visible','off') 
        set(handles.marker2Label,'visible','off') 
        set(handles.marker3Label,'visible','off') 
        set(handles.marker4Label,'visible','off') 
        set(handles.marker5Label,'visible','off') 
        set(handles.marker6Label,'visible','off')     

        set(handles.marker1PIX,'visible','off')
        set(handles.marker2PIX,'visible','off')
        set(handles.marker3PIX,'visible','off')
        set(handles.marker4PIX,'visible','off')
        set(handles.marker5PIX,'visible','off')
        set(handles.marker6PIX,'visible','off')

        set(handles.numMarkersDisplay,'visible','off')
        set(handles.numMarkersDisplay,'string','2')
        set(handles.numMarkerspopup,'visible','off')

        set(handles.numMarkersLabel,'visible','off')

        set(handles.frameNumberDisplay,'visible','off')
        set(handles.maxFrameDisplay,'visible','off')
        set(handles.analyzeButton,'visible','off')
        set(handles.analyzeButton,'visible','off')

        set(handles.frameNumberDisplay,'visible','off')
        set(handles.maxFrameDisplay,'visible','off')
        set(handles.playButton,'visible','off')
        set(handles.pauseButton,'visible','off')
        set(handles.backFrameButton,'visible','off')
        set(handles.forwardFrameButton,'visible','off')
        set(handles.fastBackFrameButton,'visible','off')
        set(handles.fastForwardFrameButton,'visible','off')
        set(handles.markIn,'visible','off')
        set(handles.markOut,'visible','off')
        set(handles.inFrameDisplay,'visible','off')
        set(handles.outFrameDisplay,'visible','off')
        set(handles.analyzeButton,'visible','off')
        set(handles.confirmButton,'visible','off')
        set(handles.tuningLabel,'visible','off')
        set(handles.movementSlider,'visible','off')
        set(handles.movementLabel,'visible','off')
        set(handles.movementDisplay,'visible','off')   
        set(handles.movementSlider,'visible','off')

        set(handles.markerShapePopup,'visible','off')
        set(handles.markerShapeLabel,'visible','off')
        set(handles.moreLabel,'visible','off')
        set(handles.lessLabel,'visible','off')
        set(handles.directionPopUp,'visible','off')
        set(handles.directionLabel,'visible','off')
        
        set(handles.sampleFreqPopup,'visible','off')
        set(handles.sampleFreqLabel,'visible','off')
        set(handles.filterPopupLabel,'visible','off')
        set(handles.filterFreqPopup,'visible','off')    
        set(handles.filterFreqPopup,'visible','off')

        set(handles.graphButton,'visible','off')
        set(handles.saveDataButton,'visible','off')
        
        set(handles.restartButton,'visible','off')

        %Distance between helment markers 1-5 in mm
        set(handles.calLength,'visible','off')
        set(handles.calDistanceLabel,'visible','off')
        
        set(handles.fontSizePopUp,'visible','off')
        set(handles.fontSizeLabel,'visible','off')


        %% 3.5.3    Clear and Reset all axes
        axes(handles.axes1)
        cla reset   
        set(handles.axes1,'visible','off') 

        axes(handles.axes11)
        cla reset
        set(handles.axes11,'visible','off')

        axes(handles.axes12)
        cla reset
        set(handles.axes12,'visible','off')

        axes(handles.axes13)
        cla reset
        set(handles.axes13,'visible','off')

        axes(handles.axes14)
        cla reset
        set(handles.axes14,'visible','off')

        axes(handles.axes16)
        cla reset
        set(handles.axes16,'visible','off') 
        
        set(handles.settingsBackground,'visible','off')

        %% 3.5.4    Initialize variables
        
        handles.settingsOpen=0;
        
        set(handles.calLength,'string','')

        set(handles.maxMarkerSizePopUp,'value',1)
        
        set(handles.numMarkerspopup,'value',7) %Note: first line is label
        handles.numMarkers=6;

        set(handles.analyzeButton,'value',0)
        handles.nowFrame=0;

        set(handles.movementSlider,'value',0.5)
        set(handles.movementDisplay,'string','1') 

        handles.movementThresh=1;

        set(handles.markerShapePopup,'value',1)
        handles.markerShape=1;

        set(handles.sampleFreqPopup,'value',3)
        handles.sampleFrequency=3200;
        handles.filterFrequency=300;
        set(handles.directionPopUp,'value',2)
        handles.directionValue=-1;
        
        
        handles.videoDirectory='';
        handles.dataDirectory='';
        set(handles.videoDirectoryDisplay,'string','')
        set(handles.dataDirectoryDisplay,'string','')
        
    %% 3.6 Read config file if it exists
        handles.fontSizeValue=4;    %Initial default for fontSizeValue (10 pt)
        
        if ispc
                disp('Running under Windows')
                if exist('C:\Users\Public\vTracker_1.0_Config.mat', 'file') == 2;
                    load('C:\Users\Public\vTracker_1.0_Config.mat');
                    
                    handles.videoDirectory=a;
                    set(handles.videoDirectoryDisplay,'string',a)
                    handles.dataDirectory=b;
                    set(handles.dataDirectoryDisplay,'string',b)
                    handles.fontSizeValue=c;
                    set(handles.fontSizePopUp,'value',c)
                    
                    handles.OS=1; 
                    lines{1}='Config file read from disk';
                    lines{2}='';
                    set(handles.promptBox,'string',lines)
                end

        else
                disp('Running under Mac OS')
                if exist('/Users/Shared/vTracker_1.0_Config.mat', 'file') == 2
                    load('/Users/Shared/vTracker_1.0_Config.mat');
                    
                    handles.videoDirectory=a;
                    set(handles.videoDirectoryDisplay,'string',a)
                    handles.dataDirectory=b;
                    set(handles.dataDirectoryDisplay,'string',b)
                    handles.fontSizeValue=c;
                    set(handles.fontSizePopUp,'value',c)
                    
                    handles.OS=2;
                    lines{1}='Config file read from disk';
                    lines{2}='';
                    set(handles.promptBox,'string',lines)
                end
        end
               
        
        %% Determine fontsize
        
        value=handles.fontSizeValue;
            switch value
                    case 1
                        handles.fontSize=4;
                    case 2
                        handles.fontSize=6;
                    case 3
                        handles.fontSize=8;
                    case 4
                        handles.fontSize=10;
                    case 5
                        handles.fontSize=12;
           end
        
        
    %% 3.7 Resize fonts of all GUI objects
        size1 =handles.fontSize;
        size15=handles.fontSize*1.5;
        size2 =handles.fontSize*2;
        
%       Make the following x2 fontsize
        set(handles.settingsBackground,'fontsize',size2);

%       Make the following x1.5 fontsize
        set(handles.playButton,'fontsize',size15);
        set(handles.pauseButton,'fontsize',size15);
        set(handles.fastBackFrameButton,'fontsize',size15); 
        set(handles.backFrameButton,'fontsize',size15);
        set(handles.forwardFrameButton,'fontsize',size15);
        set(handles.fastForwardFrameButton,'fontsize',size15);
        set(handles.markIn,'fontsize',size15);
        set(handles.markOut,'fontsize',size15);
        set(handles.inFrameDisplay,'fontsize',size15);
        set(handles.outFrameDisplay,'fontsize',size15);
        set(handles.inFrameDisplay,'fontsize',size15);
        set(handles.saveDataButton,'fontsize',size15);
        set(handles.restartButton,'fontsize',size15);
        set(handles.analyzeButton,'fontsize',size15);
        set(handles.graphButton,'fontsize',size15);
        set(handles.tuningLabel,'fontsize',size15);   
        
%      Make the following x1 fontsize
        set(handles.promptBox,'fontsize',size1);
        set(handles.newDataButton,'fontsize',size1);
        set(handles.readDataButton,'fontsize',size1);
        set(handles.calDistanceLabel,'fontsize',size1);
        set(handles.startHeadformAnalysisButton,'fontsize',size1);
        set(handles.startTouchAnalysisButton,'fontsize',size1);
        set(handles.startImpactAnalysisButton,'fontsize',size1);
        set(handles.loadHeadformVideo,'fontsize',size1);
        set(handles.loadTouchVideo,'fontsize',size1);
        set(handles.loadImpactVideo,'fontsize',size1);
     
        set(handles.directionPopUp,'fontsize',size1);
        set(handles.directionLabel,'fontsize',size1);
        set(handles.maxMarkerSizePopUp,'fontsize',size1);
        set(handles.maxMarkerSizePopUpLabel,'fontsize',size1);
        set(handles.numMarkerspopup,'fontsize',size1);
        set(handles.numMarkersLabel,'fontsize',size1);
        set(handles.markerShapePopup,'fontsize',size1);
        set(handles.markerShapeLabel,'fontsize',size1);
        set(handles.movementSlider,'fontsize',size1);
        set(handles.movementLabel,'fontsize',size1);
        set(handles.lessLabel,'fontsize',size1);
        set(handles.moreLabel,'fontsize',size1);
        set(handles.sampleFreqPopup,'fontsize',size1);
        set(handles.sampleFreqLabel,'fontsize',size1);
        set(handles.filterFreqPopup,'fontsize',size1);
        set(handles.filterPopupLabel,'fontsize',size1);
        set(handles.numMarkersDisplay,'fontsize',size1);
        set(handles.movementDisplay,'fontsize',size1);
        set(handles.quitButton,'fontsize',size1);
        set(handles.settingsButton,'fontsize',size1);
        set(handles.browseToVideoDirectory,'fontsize',size1);
        set(handles.browseToDataDirectory,'fontsize',size1);
        set(handles.marker1PIX,'fontsize',size1);
        set(handles.marker2PIX,'fontsize',size1);
        set(handles.marker3PIX,'fontsize',size1);
        set(handles.marker4PIX,'fontsize',size1);
        set(handles.marker5PIX,'fontsize',size1);
        set(handles.marker6PIX,'fontsize',size1);
        set(handles.marker1Label,'fontsize',size1);
        set(handles.marker2Label,'fontsize',size1);
        set(handles.marker3Label,'fontsize',size1);
        set(handles.marker4Label,'fontsize',size1);
        set(handles.marker5Label,'fontsize',size1);
        set(handles.marker6Label,'fontsize',size1);
        set(handles.videoDirectoryLabel,'fontsize',size1);
        set(handles.dataDirectoryLabel,'fontsize',size1);
        set(handles.videoDirectoryDisplay,'fontsize',size1);
        set(handles.dataDirectoryDisplay,'fontsize',size1);
        set(handles.playButton,'fontsize',size1);
        set(handles.pauseButton,'fontsize',size1);
        set(handles.fontSizeLabel,'fontsize',size1);
        set(handles.fontSizePopUp,'fontsize',size1);
         
  
    %% 3.8 Prompt user with options
        line{1}='';
        line{2}='Click:';
        line{3}='SETTINGS, NEW VIDEO, or PRIOR DATA';
        set(handles.promptBox,'string',line);
    
    %% 3.9 Update handles structure
    guidata(hObject, handles);
        
end

%   #04 -   settingsButton_Callback
% --- Executes on button press in settingsButton.
function settingsButton_Callback(hObject, eventdata, handles)
% hObject    handle to settingsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if handles.settingsOpen==1;
        
        %Settings menu is already open.        
        %Save directories in .mat config file
        
        if and( isfield(handles,'videoDirectory'), isfield(handles,'dataDirectory'));

            a=handles.videoDirectory;
            b=handles.dataDirectory;
            c=get(handles.fontSizePopUp,'value');

            if ispc
                disp('Running under Windows')
                disp('Config file is: C:\Users\Public\vTracker_1.0_Config.mat');
                handles.OS=1; 
                save('C:\Users\Public\vTracker_1.0_Config.mat','a','b','c')
            else
                disp('Running under Mac OS')
                disp('Config file is: /Users/Shared/vTracker_1.0_Config.mat');
                save('/Users/Shared/vTracker_1.0_Config.mat','a','b','c')
                handles.OS=2;
            end
        
            lines{1}='Config file written to disk';
            lines{2}='';
        end
        
        set(handles.promptBox,'string',lines)
        
        set(handles.browseToVideoDirectory,'visible','off')
        set(handles.browseToDataDirectory,'visible','off')

        set(handles.videoDirectoryDisplay,'visible','off')
        set(handles.dataDirectoryDisplay,'visible','off')

        set(handles.videoDirectoryLabel,'visible','off')
        set(handles.dataDirectoryLabel,'visible','off') 

        set(handles.settingsBackground,'visible','off')
    
        handles.settingsOpen=0;
        
        % Update handles structure
        guidata(hObject, handles)
        
        return
    end
    
       
    %New entry to settings menu. Set flag and Prompt User
    set(handles.settingsBackground,'visible','on')
    handles.settingsOpen=1;

    line{1}='Click:';
    line{2}='Set Video Directory'; 
    line{3}='and/or';
    line{4}='Set Data Directory';
    set(handles.promptBox,'string',line);
    
 
    %% 4.1 Show browse buttons
    set(handles.browseToVideoDirectory,'visible','on')
    set(handles.browseToDataDirectory,'visible','on')
    
    %% 4.1 Prompt User with Options
   
    set(handles.fontSizePopUp,'visible','on')
    set(handles.fontSizeLabel,'visible','on')
        
    set(handles.videoDirectoryDisplay,'visible','on')
    set(handles.videoDirectoryLabel,'visible','on')
     
    set(handles.dataDirectoryDisplay,'visible','on')
    set(handles.dataDirectoryLabel,'visible','on')   
       
    set(handles.videoDirectoryDisplay,'string',handles.videoDirectory)
    set(handles.dataDirectoryDisplay,'string',handles.dataDirectory)
       
    % Update handles structure
    guidata(hObject, handles)
end

%   #05 -   newDataButton_Callback
% --- Executes on button press in newDataButton.
function newDataButton_Callback(hObject, eventdata, handles)
    
% hObject    handle to newDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %5.1    Turn off setting menu if it was left open
    if handles.settingsOpen==1;
        
        %Settings menu is already open close it
        set(handles.browseToVideoDirectory,'visible','off')
        set(handles.browseToDataDirectory,'visible','off')
                
        set(handles.videoDirectoryDisplay,'visible','off')
        set(handles.dataDirectoryDisplay,'visible','off')
        
        set(handles.videoDirectoryLabel,'visible','off')
        set(handles.dataDirectoryLabel,'visible','off') 
        
        set(handles.settingsBackground,'visible','off')
        
        handles.settingsOpen=0;
            
        % Update handles structure
        guidata(hObject, handles)

    end

    set(handles.newDataButton,'visible','off')  
    set(handles.readDataButton,'visible','off')
    
    set(handles.loadHeadformVideo,'visible','on')
    set(handles.promptBox,'string','Click HEADFORM Button to begin')

    % Update handles structure
    guidata(hObject, handles)
end

%   #06 -   readDataButton_Callback
% --- Executes on button press in readDataButton.
function readDataButton_Callback(hObject, eventdata, handles)

    set(handles.settingsButton,'visible','off')
    set(handles.newDataButton, 'visible','off')
    set(handles.readDataButton,'visible','off')
    
    %   Data were saved as calibrated but unfiltered coordinates in mm as follows:
    %   numMarkers      - number of markers
    %   numFrames       - number of frames
    %   initialTouchDist- touch distance between markers 1 and 2
    %   frameRate       - video frame rate in frames per second

          
    %6.1  Hide settings menu if it was left open
    if handles.settingsOpen==1;

        set(handles.browseToVideoDirectory,'visible','off')
        set(handles.browseToDataDirectory,'visible','off')
                
        set(handles.videoDirectoryDisplay,'visible','off')
        set(handles.dataDirectoryDisplay,'visible','off')
        
        set(handles.videoDirectoryLabel,'visible','off')
        set(handles.dataDirectoryLabel,'visible','off') 
        
        set(handles.settingsBackground,'visible','off')
        
        handles.settingsOpen=0;
    end
        
    %6.2    Prompt User
        line{1}='Browse to existing datafile';
        set(handles.promptBox,'string',line);
        
    %6.3    Browse after checking if directory is set
        if size(handles.dataDirectory,2)~=0;
            a= handles.dataDirectory;
            cd(a)
        end
        
        [handles.dataFileName,handles.dataPathName]=uigetfile('*.*');
        inFileName=[handles.dataPathName,handles.dataFileName];
        
        %Open the file
        fid=fopen(inFileName);
        
        %Read the video file name
        handles.completeVideoFileName=fgetl(fid);
        
        %Read info line
        tline1 = fgetl(fid);
        v1=strread(tline1);
        handles.numMarkers=v1(1);
        handles.framesToAnalyze=v1(2);
        handles.compressionBaseline=v1(3);
        handles.sampleFrequency=v1(4);
        handles.filterFrequency=v1(5)
        handles.scaleFactor=v1(6);
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
           handles.calibratedImpact(1:6,jk,1)=strread(tline3);
        end

        %Read the Y coordinates of the impact data
        for jk=1:handles.framesToAnalyze;
           tline3 = fgetl(fid);
           handles.calibratedImpact(1:6,jk,2)=strread(tline3);
        end 
                
        set(handles.graphButton,'visible','on')
        line{1}='Say something here';
        set(handles.promptBox,'string',line)
%         
    % Update handles structure
    guidata(hObject, handles)
end

%   #07   browseToVideoDirectory_Callback
% --- Executes on button press in browseToVideoDirectory.
function browseToVideoDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to browseToVideoDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    line{1}='';
    line{2}='Browse to Video Directory';
    line{3}='';
    line{4}='';
    set(handles.promptBox,'string',line);
        
    handles.videoDirectory=uigetdir();
    set(handles.videoDirectoryDisplay,'string',handles.videoDirectory)
    set(handles.videoDirectoryDisplay,'visible','on')
    set(handles.videoDirectoryLabel,'visible','on')
    
       
    line{1}='Click:';
    line{2}='Set Video Directory';
    line{3}='or';
    line{4}='Click the Settings Icon to close window';
    set(handles.promptBox,'string',line);
      
    % Update handles structure
    guidata(hObject, handles)

end

%   #08   browseToDataDirectory_Callback
% --- Executes on button press in browseToDataDirectory.
function browseToDataDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to browseToDataDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    line{1}='';
    line{2}='Browse to Data Directory';
    line{3}='';
    line{4}='';
    set(handles.promptBox,'string',line);

    handles.dataDirectory=uigetdir();
    set(handles.dataDirectoryDisplay,'string',handles.dataDirectory)
    set(handles.dataDirectoryDisplay,'visible','on')
    set(handles.dataDirectoryLabel,'visible','on')
    
    line{1}='Click:';
    line{2}='Set Video Directory';
    line{3}='or';
    line{4}='Click the Settings Icon to close window';
    set(handles.promptBox,'string',line);
        
    % Update handles structure
    guidata(hObject, handles)
end

%   #09 quitButton
% --- Executes on Button press in quitButton.
function quitButton_Callback(hObject, eventdata, handles)
% hObject    handle to quitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all force
    
end

%   #10 -   loadHeadformVideo_Callback
% --- Executes on Button press in loadHeadformVideo.
function loadHeadformVideo_Callback(hObject, eventdata, handles)
% hObject    handle to loadHeadformVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.loadHeadformVideo,'visible','off')
    
    %10.05  Hide settings menu if it was left open
    if handles.settingsOpen==1;
        
        %Settings menu is already open close it
        set(handles.browseToVideoDirectory,'visible','off')
        set(handles.browseToDataDirectory,'visible','off')
                
        set(handles.videoDirectoryDisplay,'visible','off')
        set(handles.dataDirectoryDisplay,'visible','off')
        
        set(handles.videoDirectoryLabel,'visible','off')
        set(handles.dataDirectoryLabel,'visible','off') 
        
        set(handles.settingsBackground,'visible','off')
        
        handles.settingsOpen=0;
            
        % Update handles structure
        guidata(hObject, handles)
        
        return
    end
    
    
    %% Browse to and load headform video
    % 10.1  Prompt the User
    set(handles.promptBox,'string','Browse to headform calibration video file')

    
    %10.2   Change to default directory if set
    if size(handles.videoDirectory,2)~=0;
        a= handles.videoDirectory;
        cd(a)
    end
    
    
    %10.3   While loop for section of .mp4/.MP4/.mov/.MOV file
    test=0;
    while test==0;

        [handles.calFileName,handles.calPathName]=uigetfile('*.*');
        file=[handles.calPathName,handles.calFileName];

        nameLength=size(handles.calFileName,2);
        nTemp=handles.calFileName;
        extn=nTemp(1,nameLength-2:nameLength);

        if or (strcmp(extn,'mp4'), strcmp(extn,'MP4'))
            test=1;
        end
       
        if or (strcmp(extn,'mov'), strcmp(extn,'MOV'))
            test=1;
        end

        if or (strcmp(extn,'avi'), strcmp(extn,'AVI'))
            test=1;
        end
        
        if test==0
            set(handles.promptBox,'string','Invalid File extension (must be .av1, .mp4, or .mov). Make another selection')
            set(handles.loadHeadformVideo,'visible','on')
        end
    end
    
    %10.4   Display file name in promptBox
    set(handles.promptBox,'string',['Processing: ',handles.calFileName])
    pause(0.5)
    
    %10.5   VideoReader Creates a multimedia reader object. 
    vidObj=VideoReader(file);
    
    %10.6   Read the first RGB Frame
        handles.video = readFrame(vidObj);
        
    %10.7   Save number of rows and columns for later Cartesian calculations
        handles.numRows=vidObj.Height;
        handles.numCols=vidObj.Width;
        
    %10.8   Convert frame 1 to gray scale
        handles.gray  = rgb2gray(handles.video);
    
    %10.9   Show the frame in axes 1
        axes(handles.axes1)
        cla reset
        imshow(handles.gray);
        hold on        
    
    %10.10  Turn on Options to Acquire max marker size
        set(handles.maxMarkerSizePopUp,'visible','on')
        set(handles.maxMarkerSizePopUpLabel,'visible','on')
        set(handles.tuningLabel,'visible','on')
     
    %10.11  Turn on flag, show video size, and prompt user
        handles.videoID=1;   %Flag for Headform Calibration Video
        line{1}=['Video is ',num2str(handles.numRows),' x ',num2str(handles.numCols)];
        line{2}='Choose Max Marker Size from pull-down menu';
        set(handles.promptBox,'string',line)
    
    % Update handles structure
    guidata(hObject, handles);
    
end

%   #11 -   maxMarkerSizePopUp_Callback
% --- Executes on selection change in maxMarkerSizePopUp.
function maxMarkerSizePopUp_Callback(hObject, eventdata, handles)
% hObject    handle to maxMarkerSizePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns maxMarkerSizePopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from maxMarkerSizePopUp

    abc=get(handles.maxMarkerSizePopUp,'value');
    
    switch abc
        case 2
            handles.maxMarkerSize=100;
        case 3
            handles.maxMarkerSize=500;
        case 4
            handles.maxMarkerSize=1000;
        case 5
            handles.maxMarkerSize=2000;
    end
    
    % Update handles structure
    guidata(hObject, handles); 
    
    switch handles.videoID
        case 1
            set(handles.startHeadformAnalysisButton,'visible','on')
            set(handles.promptBox,'string','Click START when ready to analyze headform calibration video')
        case 2
            set(handles.startTouchAnalysisButton,'visible','on')
            set(handles.promptBox,'string','Click START when ready to analyze touch video')
        case 3
            set(handles.analyzeButton,'visible','on')
            set(handles.promptBox,'string','Click ANALYZE when ready to analyze impact video')
    end

end

%   #12 -   maxMarkerSizePopUp_CreateFcn
% --- Executes during object creation, after setting all properties.
function maxMarkerSizePopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxMarkerSizePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #13  startHeadformAnalysisButton_Callback
% --- Executes on button press in startHeadformAnalysisButton.
function startHeadformAnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to startHeadformAnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%   13.1    Turn off buttons

    set(handles.startHeadformAnalysisButton,'visible','off') 
    set(handles.maxMarkerSizePopUp,'visible','off')
    set(handles.maxMarkerSizePopUpLabel,'visible','off')
    set(handles.tuningLabel,'visible','off')
   
%   13.2    Create RGB Channels for superposition of selected pixels
    redImage=handles.gray;
    greenImage=handles.gray;
    blueImage=handles.gray;

%   13.3    Show prompt picture
    axes(handles.axes16)
    imshow('Headform_Order.png')
    pause(2)
   
%   13.4    Start loop for Acquisition of three markers

    %Change the focus back to to axis1 where image is shown
    axes(handles.axes1)
     
 for jm=1:3 
        foundPixels=10000;
        
        %13.5   Region Growing
        while foundPixels>=handles.maxMarkerSize-10 %Search stops when lower value set
            deltaThresh(jm)=0.1;
            set(handles.promptBox,'string',['Identify marker #',num2str(jm)]);
            ax = gca;
            [mx,my]=ginput(1);

            mx=fix(mx);
            my=fix(my);
            
            %Region grow the area with a maximum difference of deltaThresh
            %  This is specific for each marker

            dFrame=im2double(handles.gray);        

            J = regionGrowing(dFrame,my,mx,deltaThresh(jm),handles.maxMarkerSize);
            foundPixels=length(J(J==1));

       %13.6   Display the grown region
            %Apply the found pixels as a mask to the channels
            redImage(J)=255;
            greenImage(J) = 0;
            blueImage(J) = 0;

            %Concatenate the channels and display
            rgbImage = cat(3, redImage, greenImage, blueImage);

            %Display the colored image
            cla reset
            imshow(rgbImage)
            hold on
            
       %13.7   Generate a property object for the grown area. 
       %       This operates by finding connected regions of 1's

            stats = regionprops(J,'all');         
            
       %13.8   Check for Error Condition
            numRegions=numel(stats);
            if numRegions>1
                set(handles.promtBox,'string','Error: More than 1 region found for this marker')
                return
            end
            
       %13.9    Otherwise, save region details and plot a white * 

            handles.headformCentroid(jm,1)=stats.Centroid(1);
            handles.headformCentroid(jm,2)=stats.Centroid(2);

            plot(handles.headformCentroid(jm,1),handles.headformCentroid(jm,2),'*w'); 

            diameter(jm) =  stats.EquivDiameter;
            pixels(jm)   =  stats.Area;

                switch jm
                     case 1
                        set(handles.marker1PIX,'visible','on')
                        set(handles.marker1PIX,'string',num2str(pixels(jm)+1));
                        set(handles.marker1Label,'visible','on') 
                     case 2
                        set(handles.marker2PIX,'visible','on')
                        set(handles.marker2PIX,'string',num2str(pixels(jm)+1));
                        set(handles.marker2Label,'visible','on')                 
                     case 3
                        set(handles.marker3PIX,'visible','on')
                        set(handles.marker3PIX,'string',num2str(pixels(jm)+1));
                        set(handles.marker3Label,'visible','on')      
                end
                
         %13.10 Check for Target size exceeded
                
                if foundPixels>=handles.maxMarkerSize-1;
                      line{1}='TARGET SIZE EXCEEDED. Repeat acqusition of Markers with new Max Target Size and/or locate center of marker more precisely';
                      line{2}='Choose new Max Marker Size';
                      set(handles.promptBox,'string',line)

                      set(handles.marker1PIX,'visible','off')
                      set(handles.marker1Label,'visible','off') 
                      set(handles.marker2PIX,'visible','off')
                      set(handles.marker2Label,'visible','off')                          
                      set(handles.marker3PIX,'visible','off')
                      set(handles.marker3Label,'visible','off') 
                      
                      %Wipe then redisplay video image
                          
                      axes(handles.axes1)
                      cla reset
                      imshow(handles.gray);
                      hold on
                      
                      %Turn on Max Marker Size pull-down
                      set(handles.maxMarkerSizePopUp,'visible','on')
                      set(handles.maxMarkerSizePopUpLabel,'visible','on')
                      set(handles.tuningLabel,'visible','on')                    
                      %Exit 
                      return
                end
        end
 end
   
     % 3.11   Calculate distance between headform markers 1 and 3
     xDist=handles.headformCentroid(1,1)-handles.headformCentroid(3,1);
     yDist=handles.headformCentroid(1,2)-handles.headformCentroid(3,2);
     handles.d1=sqrt(xDist^2+yDist^2);
     d1=handles.d1;
     
     %13.12  Control visibility and prompt user
     set(handles.loadHeadformVideo,'visible','off')  
     set(handles.calLength,'visible','on')
     set(handles.calDistanceLabel,'visible','on')    
     set(handles.maxMarkerSizePopUp,'value',1)
     set(handles.loadTouchVideo,'visible','on') 
     
     axes(handles.axes16)
     cla reset
     imshow('Headform_Linear_Cal.png') 
     
     set(handles.restartButton,'visible','on')
     handles.sequence=1; %Identifies headform analysis in case of restart
   
     line{1}='Enter Measured Length between Markers 1 and 3 (in mm) then click on TOUCH Button to continue';
     line{2}='or Click RESTART to repeat marker acquisition';
     set(handles.promptBox,'string',line)
   
    % Update handles structure
    guidata(hObject, handles);
end

%   #14 -    regionGrowing
function J=regionGrowing(I,x,y,reg_maxdist,regLimit);   %prc line 04.16.16
%function J=regionGrowing(I,x,y,reg_maxdist);           %original line

% This function performs "region growing" in analyzeButton image from a specified
% seedpoint (x,y)
%
% J = regiongrowing(I,x,y,t) 
% 
% I : input image 
% J : logical output image of region
% x,y : the position of the seedpoint (if not given uses function getpts)
% t : maximum intensity distance (defaults to 0.2)
%
% The region is iteratively grown by comparing all und neighbouring pixels to the region. 
% The difference between a pixel's intensity value and the region's mean, 
% is used as a measure of similarity. The pixel with the smallest difference 
% measured this way is d to the respective region. 
% This process stops when the intensity difference between region mean and
% new pixel become larger than a certain threshold (t)
%
% Example:
%
% I = im2double(imread('medtest.png'));
% x=198; y=359;
% J = regiongrowing(I,x,y,0.2); 
% figure, imshow(I+J);
%
% Author: D. Kroon, University of Twente

%% #1 Check Arguments
if(exist('reg_maxdist','var')==0), reg_maxdist=0.2; end
if(exist('y','var')==0), figure, imshow(I,[]); [y,x]=getpts; y=round(y(1)); x=round(x(1)); end

%% #2 Initialize output array to 0; Get image dimensions
J = zeros(size(I)); % Output 
Isizes = size(I);   % Dimensions of input image

%% #3 Set initial region mean and size to seed pixel and distance to zero
reg_mean = I(x,y); % The mean of the segmented region
reg_size = 1; % Number of pixels in region
pixdist=0; % Distance of the region newest pixel to the region mean

%% #4 Free memory to store neighbours of the (segmented) region
neg_free = 10000; neg_pos=0;
neg_list = zeros(neg_free,3); 

%% #5 Set matrix for relative neighbor locations
neigb=[-1 0; 1 0; 0 -1;0 1];


%% #6 Start region growing until distance between region and possible new pixels become
% higher than a certain threshold

%while(pixdist<reg_maxdist&&reg_size<numel(I));     %Original line
while(pixdist<reg_maxdist&&reg_size<regLimit)  ;    %prc change 04.16.16

    % 6.1 Add new neighbors pixels
    for j=1:4,
        % 6.1.1 Calculate the neighbour coordinate
        xn = x +neigb(j,1); yn = y +neigb(j,2);
        
        % 6.1.2 Check if neighbour is inside or outside the image
        ins=(xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));
        
        % 6.1.3 Add neighbor if inside and not already part of the segmented area
        if(ins&&(J(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn I(xn,yn)]; J(xn,yn)=1;
        end
    end

    % 6.2 Add a new block of free memory
    if(neg_pos+10>neg_free), neg_free=neg_free+10000; neg_list((neg_pos+1):neg_free,:)=0; end
    
    % 6.3 Add pixel with intensity nearest to the mean of the region, to the region    
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist, index] = min(dist);
    
    % 6.4 Set current pixel J value to 2 to stop it being added again
    %     and increment region size
    J(x,y)=2; reg_size=reg_size+1;
    
    % 6.5 Calculate the new mean intensity of the region
    reg_mean= (reg_mean*reg_size + neg_list(index,3))/(reg_size+1);
    
    % 6.6 Save the x and y coordinates of the pixel (for the neighbour add proccess)
    x = neg_list(index,1); y = neg_list(index,2);
    
    % 6.7 Remove the pixel from the neighbour (check) list
    neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
end

% Return the segmented area as logical matrix
J=J>1;
end

%   #15 -   restartButton
% --- Executes on button press in restartButton.
function restartButton_Callback(hObject, eventdata, handles)
% hObject    handle to restartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.restartButton,'visible','off')
    abc=handles.sequence;
    switch abc
        case 1
            % Restart Headform calibration
            % Show new copy of frame 1 in axes1
            axes(handles.axes1)
            cla reset            
            imshow(handles.gray);
            
            %Tun off calibration length, touch buttons, and cal diagram
             set(handles.calLength,'visible','off')
             set(handles.calDistanceLabel,'visible','off')    
             set(handles.loadTouchVideo,'visible','off') 
             set(handles.axes16,'visible','off')

            % reset maxMarkerSize
            set(handles.maxMarkerSizePopUp,'value',1)
            set(handles.maxMarkerSizePopUp,'visible','on')
            set(handles.maxMarkerSizePopUpLabel,'visible','on')            
            set(handles.tuningLabel,'visible','on')
          
            % Overwrite prior marker sizes
            set(handles.marker1PIX,'string','')
            set(handles.marker2PIX,'string','')
            set(handles.marker2PIX,'string','')
            
            % Turn on flag, show video size, and prompt user            
            handles.videoID=1;   %Flag for Headform Calibration Video
            line{1}=['Video is ',num2str(handles.numRows),' x ',num2str(handles.numCols)];
            line{2}='Choose Max Marker Size from pull-down menu to restart';
            set(handles.promptBox,'string',line)
            
        case 2
            %Restart Touch analysis
            % Show new copy of frame 1 in axes1
            axes(handles.axes1)
            cla reset            
            imshow(handles.gray2);
            
            %Turn off impact button  
            set(handles.loadImpactVideo,'visible','off') 

            % reset maxMarkerSize
            set(handles.maxMarkerSizePopUp,'value',1)
            set(handles.maxMarkerSizePopUp,'visible','on')
            set(handles.maxMarkerSizePopUpLabel,'visible','on')            
            set(handles.tuningLabel,'visible','on')
           
            % Overwrite prior marker sizes
            set(handles.marker1PIX,'string','')
            set(handles.marker2PIX,'string','')
            
            % Turn on flag, show video size, and prompt user            
            handles.videoID=2;   %Flag for Touch Calibration Video
            line{1}=['Video is ',num2str(handles.numRows),' x ',num2str(handles.numCols)];
            line{2}='Choose Max Marker Size from pull-down menu to restart';
            set(handles.promptBox,'string',line)
            
        case 3
            %restart impact analysis
            %Turn off start button
            set(handles.startImpactAnalysisButton,'visible','off') 
             
            % Show new copy of start frame in axes1
            axes(handles.axes1)
            cla reset            
            showFrame(:,:)=handles.grayFrame(handles.inFrameNumber,:,:);
            imshow(showFrame);
            hold on
            
            % reset maxMarkerSize
            set(handles.maxMarkerSizePopUp,'value',1)
            set(handles.maxMarkerSizePopUp,'visible','on')
            set(handles.maxMarkerSizePopUpLabel,'visible','on')            
            set(handles.tuningLabel,'visible','on')
           
            % Overwrite prior marker sizes
            set(handles.marker1PIX,'string','')
            set(handles.marker2PIX,'string','')
            set(handles.marker3PIX,'string','')
            set(handles.marker4PIX,'string','')
            set(handles.marker5PIX,'string','')
            set(handles.marker6PIX,'string','')
             
            % Turn on flag, show video size, and prompt user            
            handles.videoID=3;   %Flag for Impact  Video
            line{1}=['Video is ',num2str(handles.numRows),' x ',num2str(handles.numCols)];
            line{2}='Choose Max Marker Size from pull-down menu to restart';
            set(handles.promptBox,'string',line)
            
    end
    
    %Update handles structure
    guidata(hObject, handles);   
end

%   #16 -   loadTouchVideo_Callback
% --- Executes on button press in loadTouchVideo.
function loadTouchVideo_Callback(hObject, eventdata, handles)
% hObject    handle to loadTouchVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    set(handles.restartButton,'visible','off')
       
    axes(handles.axes16)
    cla reset
    set(handles.axes16,'visible','off')
    
    axes(handles.axes1)
    cla reset
    set(handles.axes1,'visible','off')
    set(handles.promptBox,'string','Browse to the TOUCH calibration video file')
    
    %Get the calibration length
    handles.actualCalLength=str2num(get(handles.calLength,'string'));
    set(handles.calLength,'visible','off')
    set(handles.calDistanceLabel,'visible','off')
    
    %Calculate scale factor in mm/screen unit
    handles.scaleFactor=handles.actualCalLength/handles.d1;
    
    %Turn off marker info from Linear calibration video
    set(handles.loadTouchVideo,'visible','off')
	set(handles.marker1PIX,'visible','off')
	set(handles.marker1Label,'visible','off') 

	set(handles.marker2PIX,'visible','off')
	set(handles.marker2Label,'visible','off')                 

	set(handles.marker3PIX,'visible','off')
	set(handles.marker3Label,'visible','off')  

    
    %%  Browse to video file and read it 
    %   Check to see if video driectory was set in Settings menu
    if size(handles.videoDirectory,2)~=0;
        a= handles.videoDirectory;
        cd(a)
    end
       
    test=0;
    while test==0;

        [handles.touchFileName,handles.touchPathName]=uigetfile('*.*');
        file=[handles.touchPathName,handles.touchFileName];

        nameLength=size(handles.touchFileName,2);
        nTemp=handles.touchFileName;
        extn=nTemp(1,nameLength-2:nameLength);

        if or (strcmp(extn,'mp4'), strcmp(extn,'MP4'))
            test=1;
        end
       
        if or (strcmp(extn,'mov'), strcmp(extn,'MOV'))
            test=1;
        end

        if or (strcmp(extn,'avi'), strcmp(extn,'AVI'))
            test=1;
        end
        
        if test==0
            set(handles.promptBox,'string','Invalid File extension (must be .av1, .mp4, or .mov). Make another selection')
        end
    end
    
    %Display file name in promptBox
    set(handles.promptBox,'string',['Processing: ',handles.touchFileName])
    pause(0.5)
    
    %VideoReader Creates a multimedia reader object. 
    vidObj=VideoReader(file);
    
    %Read the first RGB Frame
        handles.video2 = readFrame(vidObj);
        
%     %Save number of rows and columns for later Cartesian calculations
%         handles.numRows=vidObj.Height;
%         handles.numCols=vidObj.Width;
        
    %Convert to gray scale
        handles.gray2  = rgb2gray(handles.video2);
    %Show the frame in axes 1
 
        axes(handles.axes1)
        cla reset
        imshow(handles.gray2);
        hold on
        set(handles.axes1,'visible','on')
        
        set(handles.maxMarkerSizePopUp,'visible','on')
        set(handles.maxMarkerSizePopUpLabel,'visible','on')
        set(handles.tuningLabel,'visible','on')
        %Acquire max marker size
        set(handles.promptBox,'string','Choose Max Marker Size from pull-down menu')
        handles.videoID=2;   %Flag for Touch Video
    
    % Update handles structure
    guidata(hObject, handles);

end

%   #17 -   startTouchAnalysisButton_Callback
% --- Executes on button press in stafrtTouchAnalysisButton.
function startTouchAnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to startTouchAnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    handles.sequence=2; %Identifies touchVideo analysis in case of restart
    % Update handles structure
    guidata(hObject, handles);
    
    set(handles.startTouchAnalysisButton,'visible','off') 
    set(handles.maxMarkerSizePopUp,'visible','off')
    set(handles.maxMarkerSizePopUpLabel,'visible','off')
    set(handles.tuningLabel,'visible','off')
   
    %Create RGB Channels for superposition of selected pixels
    redImage=handles.gray2;
    greenImage=handles.gray2;
    blueImage=handles.gray2;
        
    %Acquire the targets
    set(handles.promptBox,'string','Click on targets in the order shown')
    axes(handles.axes16)
    cla reset
    imshow('Touch_Calibration.png')
    pause(2)     
 
    %Start loop for ID of two markers
    
 for jm=1:2 
        foundPixels=10000;
        while foundPixels>=handles.maxMarkerSize-10 %Seach stops 
            deltaThresh(jm)=0.2;
            set(handles.promptBox,'string',['Identify marker #',num2str(jm)]);
            [mx,my]=ginput(1);

            mx=fix(mx);
            my=fix(my);

            %Region grow the area with a maximum difference of deltaThresh
            %  This is specific for each marker

            dFrame=im2double(handles.gray2);        

            J = regionGrowing(dFrame,my,mx,deltaThresh(jm),handles.maxMarkerSize);
            foundPixels=length(J(J==1));

            %Apply the found pixels as a mask to the channels
            redImage(J)=255;
            greenImage(J) = 0;
            blueImage(J) = 0;

            %Concatenate the channels and display
            rgbImage = cat(3, redImage, greenImage, blueImage);

            %Display the colored image
            cla reset
            imshow(rgbImage)
            hold on

            %Generate a property object for the grown area. This operates by
            %finding connected regions of 1's

            stats = regionprops(J,'all');
            numRegions=numel(stats);
            if numRegions>1
                set(handles.promtBox,'string','Error: More than 1 region found for this marker')
            end

            handles.touchCentroid(jm,1)=stats.Centroid(1);
            handles.touchCentroid(jm,2)=stats.Centroid(2);

            plot(handles.touchCentroid(jm,1),handles.touchCentroid(jm,2),'*w'); 

            diameter(jm) =  stats.EquivDiameter;
            pixels(jm)   =  stats.Area;

                switch jm
                     case 1
                        set(handles.marker1PIX,'visible','on')
                        set(handles.marker1PIX,'string',num2str(pixels(jm)+1));
                        set(handles.marker1Label,'visible','on') 
                     case 2
                        set(handles.marker2PIX,'visible','on')
                        set(handles.marker2PIX,'string',num2str(pixels(jm)+1));
                        set(handles.marker2Label,'visible','on')                    
                end
                
                if foundPixels>=handles.maxMarkerSize-1;
                    disp('here')
                      set(handles.promptBox,'string','TARGET SIZE EXCEEDED. Repeat acqusition of Markers with new Max Target Size and/or locate Center of marker more precisely')
                      pause (2)
                      set(handles.promptBox,'string','Choose Max Marker Size')

                      set(handles.marker1PIX,'visible','off')
                      set(handles.marker1Label,'visible','off') 
                      set(handles.marker2PIX,'visible','off')
                      set(handles.marker2Label,'visible','off')                          
                      set(handles.marker3PIX,'visible','off')
                      set(handles.marker3Label,'visible','off') 
                      
                      %Wipe then redisplay video image
                          
                      axes(handles.axes1)
                      cla reset
                      imshow(handles.gray2);
                      hold on
                      
                      %Turn on Max Marker Size pull-down
                      set(handles.maxMarkerSizePopUp,'visible','on')
                      set(handles.maxMarkerSizePopUpLabel,'visible','on')
                      set(handles.tuningLabel,'visible','on')                    
                      %Exit 
                      return
                end
        end
 end
    
     %% Calculate distance between markers 1 and 2 in pixels for later compression measure
     xDist=handles.touchCentroid(1,1)-handles.touchCentroid(2,1);
     yDist=handles.touchCentroid(1,2)-handles.touchCentroid(2,2);
     handles.compressionBaseline=sqrt(xDist^2+yDist^2);
    
     %Convert distance to mm
     handles.compressionBaseline=handles.compressionBaseline*handles.scaleFactor;
     
     set(handles.loadTouchVideo,'visible','off')
     set(handles.loadImpactVideo,'visible','on')
     set(handles.restartButton,'visible','on')
         
     line{1}='Click IMPACT to browse to impact video';
     line{2}='or RESTART to repeat marker acquisition';
     set(handles.promptBox,'string',line)

    % Update handles structure
    guidata(hObject, handles);

end

%   #18 -   Load and parse helmet video
% --- Executes on Button press in loadImpactVideo.
function loadImpactVideo_Callback(hObject, eventdata, handles)
% hObject    handle to loadImpactVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % space for video {Matlab complains that they are too long}
%     video(1:1000,1:720,1:1152,1:3)=zeros;
%     gray(1:1000,1:720,1:1152)=zeros;
%     videoFrame(1:200,1:720,1:1152)=zeros;

    %handles.centroid(1:5,1:1000)=zeros;
    
    set(handles.restartButton,'visible','off')
    axes(handles.axes16)
    cla reset
    set(handles.axes16,'visible','off')
     
    axes(handles.axes1)
    cla reset
    set(handles.axes1,'visible','off')
     
    set(handles.loadImpactVideo,'visible','off')
	set(handles.marker1PIX,'visible','off')
	set(handles.marker1Label,'visible','off') 

	set(handles.marker2PIX,'visible','off')
	set(handles.marker2Label,'visible','off')                 
   

    
    %%  Browse to video file and read it  
    %   Change to default directory if set
    if size(handles.videoDirectory,2)~=0;
        a= handles.videoDirectory;
        cd(a)
    end
    
    set(handles.promptBox,'string','BROWSE TO IMPACT VIDEO FILE')


    
        %10.3   While loop for section of .mp4/.MP4/.mov/.MOV file
    test=0;
    while test==0;

        [handles.vidFileName,handles.vidPathName]=uigetfile('*.*');
        file=[handles.vidPathName,handles.vidFileName];
        handles.completeVideoFileName=file;

        nameLength=size(handles.vidFileName,2);
        nTemp=handles.vidFileName;
        extn=nTemp(1,nameLength-2:nameLength);

        if or (strcmp(extn,'mp4'), strcmp(extn,'MP4'))
            test=1;
        end
       
        if or (strcmp(extn,'mov'), strcmp(extn,'MOV'))
            test=1;
        end

        if or (strcmp(extn,'avi'), strcmp(extn,'AVI'))
            test=1;
        end
        
        if test==0
            set(handles.promptBox,'string','Invalid File extension (must be .av1, .mp4, or .mov). Make another selection')
        end
    end
          
    %Display file name in promptBox
    set(handles.promptBox,'string',['Processing: ',handles.vidFileName])
    pause(0.5)
    
    %Read all frames of video
    inc=0;
    
    h = waitbar(0,'Parsing video file...');
    %Assume there are 200 frames for waitbar
    
    %VideoReader Creates a multimedia reader object containing all frames. 
    vidObj=VideoReader(file);
    while hasFrame(vidObj)
        inc=inc+1;    
        %Read RGB Frame
        video = readFrame(vidObj);
        %Convert to gray scale
        gray  = rgb2gray(video);
        %Save in frame array
        handles.grayFrame(inc,:,:)=gray(:,:);
        waitbar(inc/200,h)
          
    end;
    close(h)
    handles.numFrames=inc;
    

    %Show first frame in axes 1
    axes(handles.axes1)
    cla reset
    showFrame(:,:)=handles.grayFrame(1,:,:);
    imshow(showFrame);
    hold on
    
    %Save handles for external routine
    setappdata(0,'figureHandle',gcf);
    setappdata(gcf,'axesHandle1',handles.axes1);
    
    set(handles.axes1,'visible','on')
    set(handles.frameNumberDisplay,'visible','on')
    set(handles.frameNumberDisplay,'string','1')
    set(handles.maxFrameDisplay,'visible','on')
    set(handles.maxFrameDisplay,'string',['/',num2str(handles.numFrames)]);
    set(handles.promptBox,'string',['Ready to play ',handles.vidFileName])
    set(handles.playButton,'visible','on')

    
    % Update handles structure
    guidata(hObject, handles);
    
end

%   #19 -   playButton
% --- Executes on play Button press
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to play Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %Play the gray scale video start to finish
    set(handles.pauseButton,'visible','on')
    set(handles.promptBox,'string',['Playing: ',handles.vidFileName])
    set(handles.frameNumberDisplay,'visible','on')
    set(handles.maxFrameDisplay,'visible','on')
    set(handles.maxFrameDisplay,'string',['/',num2str(handles.numFrames)]);
    set(handles.pauseButton,'visible','on')
    set(handles.axes1,'visible','on')
    cla reset
    
        for jk=handles.nowFrame+1:handles.numFrames
            set(handles.frameNumberDisplay,'string',num2str(jk))
            pause(.01)
            cla reset
            showFrame(:,:)=handles.grayFrame(jk,:,:);
            imshow(showFrame);
            if (get(handles.pauseButton,'value'))==1
                %Pause Button was pressed
                handles.nowFrame=jk;
                
                %Turn off pause Button so it can be used again
                set(handles.pauseButton,'value',0)
                
                % Update handles structure
                guidata(hObject, handles);
                break
            end
        end
end

%   #20 -   pauseButton
% --- Executes on pause Button press
function pauseButton_Callback(hObject, eventdata, handles)
% hObject    handle to pauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.backFrameButton,'visible','on')
    set(handles.forwardFrameButton,'visible','on')
    set(handles.fastForwardFrameButton,'visible','on')
    set(handles.fastBackFrameButton,'visible','on')
    set(handles.pauseButton,'visible','off')
    set(handles.markIn,'visible','on')
    set(handles.markOut,'visible','on')
    
    set(handles.promptBox,'string','Mark IN and OUT frames { and }')

    % Update handles structure
    guidata(hObject, handles);
    
end

%   #21 -   backFrameButton
%% 
% --- Executes on backFrameButton press
function backFrameButton_Callback(hObject, eventdata, handles)
% hObject    handle to backFrameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    now=handles.nowFrame-1;
    handles.nowFrame=handles.nowFrame-1;
    if now<1
        now=1;
        handles.nowFrame=1;
    end
    set(handles.frameNumberDisplay,'string',num2str(handles.nowFrame));
    
    showFrame(:,:)=handles.grayFrame(handles.nowFrame,:,:);
    cla reset
    imshow(showFrame);

    % Update handles structure
    guidata(hObject, handles);
    
end

%   #22 -   forwardFrameButton
% --- Executes on Button press
function forwardFrameButton_Callback(hObject, eventdata, handles)
% hObject    handle to forwardFrameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    now=handles.nowFrame+1;
    handles.nowFrame=handles.nowFrame+1;
    if now>handles.numFrames;
        now=handles.numFrames;
        handles.nowFrame=handles.numFrames;
    end
    set(handles.frameNumberDisplay,'string',num2str(handles.nowFrame))
    
    showFrame(:,:)=handles.grayFrame(handles.nowFrame,:,:);
    cla reset
    imshow(showFrame);

    % Update handles structure
    guidata(hObject, handles);
end

%   #23 -   fastBackFrameButton
% --- Executes on Button press
function fastBackFrameButton_Callback(hObject, eventdata, handles)
% hObject    handle to fastBackFrameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    now=handles.nowFrame-10;
    handles.nowFrame=handles.nowFrame-10;
    if now<1
        now=1;
        handles.nowFrame=1;
    end
    set(handles.frameNumberDisplay,'string',num2str(handles.nowFrame))
    
    showFrame(:,:)=handles.grayFrame(now,:,:);
    cla reset
    imshow(showFrame);

    % Update handles structure
    guidata(hObject, handles);
end

%   #24 -   fastForwardFrameButton
% --- Executes on Button press 
function fastForwardFrameButton_Callback(hObject, eventdata, handles)
% hObject    handle to fastForwardFrameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    now=handles.nowFrame+10;
    handles.nowFrame=handles.nowFrame+10;
    if now>handles.numFrames;
        now=handles.numFrames;
        handles.nowFrame=handles.numFrames;
    end
    set(handles.frameNumberDisplay,'string',num2str(handles.nowFrame))
    
    showFrame(:,:)=handles.grayFrame(handles.nowFrame,:,:);
    cla reset
    imshow(showFrame);

    % Update handles structure
    guidata(hObject, handles);
    
end

%   #25 -   Mark In  
% --- Executes on Button press in markIn.
function markIn_Callback(hObject, eventdata, handles)
% hObject    handle to markIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.inFrameNumber=handles.nowFrame;
    set(handles.inFrameDisplay,'string',num2str(handles.nowFrame))
    set(handles.inFrameDisplay,'visible','on')
    
    % Update handles structure
    guidata(hObject, handles);    
end

%   #26 -   Mark Out  
% --- Executes on Button press in markOut.
function markOut_Callback(hObject, eventdata, handles)
% hObject    handle to markOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.outFrameNumber=handles.nowFrame;
    set(handles.outFrameDisplay,'string',num2str(handles.nowFrame))
    set(handles.outFrameDisplay,'visible','on')
    set(handles.confirmButton,'visible','on')
    
    % Update handles structure
    guidata(hObject, handles);    
end

%   #27 -   inframedisplay 
% --- Executes on Button press in inFrameDisplay.
function inFrameDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to inFrameDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

%   #28 -   outFramedisplay
% --- Executes on Button press in outFrameDisplay.
function outFrameDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to outFrameDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

%   #29 -   analyzeButton
% --- Executes on Button press in analyzeButton.
function analyzeButton_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.frameNumberDisplay,'visible','off')
    set(handles.maxFrameDisplay,'visible','off')
    set(handles.playButton,'visible','off')
    set(handles.pauseButton,'visible','off')
    set(handles.backFrameButton,'visible','off')
    set(handles.forwardFrameButton,'visible','off')
    set(handles.fastBackFrameButton,'visible','off')
    set(handles.fastForwardFrameButton,'visible','off')
    set(handles.markIn,'visible','off')
    set(handles.markOut,'visible','off')
    set(handles.inFrameDisplay,'visible','off')
    set(handles.outFrameDisplay,'visible','off')
    set(handles.analyzeButton,'visible','off')
   
%     % storage for result
%     handles.meanX(1:1000,1:5) =zeros;
%     handles.meanY(1:1000,1:5) =zeros;  
%     handles.bright(1:1000,1:5)=zeros;
    
    %Turn on Frame number displays
    set(handles.frameNumberDisplay,'visible','on');
    set(handles.maxFrameDisplay,'visible','on');
    handles.framesToAnalyze=handles.outFrameNumber-handles.inFrameNumber+1;
    set(handles.frameNumberDisplay,'string',num2str(handles.inFrameNumber));
    set(handles.maxFrameDisplay,'string',num2str(handles.outFrameNumber));
    
    %Set restart flag
    handles.sequence=3; %Identifies impact analysis in case of restart
    % Update handles structure
    guidata(hObject, handles);
    
    %Work on the inFrame first
    cla reset 
    pause(.01)
    showFrame(:,:)=handles.grayFrame(handles.inFrameNumber,:,:);
    imshow(showFrame);
    hold on
    
    %Create RGB Channels for superposition of selected pixels
    redImage=showFrame;
    greenImage=showFrame;
    blueImage=showFrame;
 
    %Start loop for initial ID of all markers

    set(handles.promptBox,'string','Click on targets in the order shown')
    axes(handles.axes16)
    cla reset
    imshow('6_Pt_Helmet_order.png')
    pause(1)
   
    for jm=1:handles.numMarkers 
        deltaThresh(jm)=0.2;
        set(handles.promptBox,'string',['Identify marker #',num2str(jm)]);     
        [mx,my]=ginput(1);
        pause(1)% Debounce clicks
              
        mx=fix(mx);
        my=fix(my);
         
        %Region grow the area with a maximum difference of deltaThresh
        %  This is specific for each marker
         
        dFrame=im2double(showFrame);        

     
        J = regionGrowing(dFrame,my,mx,deltaThresh(jm),handles.maxMarkerSize);        
        %check if region limit was exceeded
        foundPixels=length(dFrame(dFrame==1));
         
        %Apply the found pixels as a mask to the channels
        redImage(J)=255;
        greenImage(J) = 0;
        blueImage(J) = 0;
         
        %Concatenate the channels and display
        rgbImage = cat(3, redImage, greenImage, blueImage);

        %Display the colored image
        cla reset
        imshow(rgbImage)
        hold on
        
        %plot([1 1152],[1 720],'r-','linewidth',6)
        
        %Save this image as grayscale to keep info when next marker is displayed
        showFrame=rgb2gray(rgbImage);
            
        %Generate a property object for the grown area. This operates by
        %finding connected regions of 1's
         
        stats = regionprops(J,'all');
        numRegions=numel(stats);
        if numRegions>1
            set(handles.promtBox,'string','Error: More than 1 region found for this marker')
        end
         
        handles.centroid(jm,1,1)=stats.Centroid(1);
        handles.centroid(jm,1,2)=stats.Centroid(2);
        
        plot(handles.centroid(jm,1,1),handles.centroid(jm,1,2),'*w'); 
        
        handles.diameter(jm) =  stats.EquivDiameter;
        pixels(jm)   =  stats.Area;
        
%         %Calculate and draw search box for next frame starting in upper left
%         side(jm)=diameter(jm)*(1+handles.movementThresh);
%         boxXCO(jm,:) = fix([handles.centroid(jm,1,1)-side(jm)/2 handles.centroid(jm,1,1)-side(jm)/2 handles.centroid(jm,1,1)+side(jm)/2 ...
%                             handles.centroid(jm,1,1)+side(jm)/2 ,handles.centroid(jm,1,1)-side(jm)/2]);
%         boxYCO(jm,:) = fix([handles.centroid(jm,1,2)-side(jm)/2 handles.centroid(jm,1,2)+side(jm)/2 handles.centroid(jm,1,2)+side(jm)/2 ...
%                             handles.centroid(jm,1,2)-side(jm)/2 ,handles.centroid(jm,1,2)-side(jm)/2]);                    
%                   
%         plot(boxXCO(jm,:),boxYCO(jm,:),'g-')
        
        %Show number of pixels in each marker   
        switch jm
             case 1
                set(handles.marker1PIX,'visible','on')
                set(handles.marker1PIX,'string',num2str(pixels(jm)));
                set(handles.marker1Label,'visible','on') 
             case 2
                set(handles.marker2PIX,'visible','on')
                set(handles.marker2PIX,'string',num2str(pixels(jm)));
                set(handles.marker2Label,'visible','on')                 
             case 3
                set(handles.marker3PIX,'visible','on')
                set(handles.marker3PIX,'string',num2str(pixels(jm)));
                set(handles.marker3Label,'visible','on')                 
             case 4
                set(handles.marker4PIX,'visible','on')
                set(handles.marker4PIX,'string',num2str(pixels(jm)));
                set(handles.marker4Label,'visible','on')                 
             case 5
                set(handles.marker5PIX,'visible','on')
                set(handles.marker5PIX,'string',num2str(pixels(jm)));
                set(handles.marker5Label,'visible','on')
            case 6
                set(handles.marker6PIX,'visible','on')
                set(handles.marker6PIX,'string',num2str(pixels(jm)));
                set(handles.marker6Label,'visible','on')
        end
        %Wait for display refesh
        pause(0.5)
    end
     
    %Wait for last marker fill
    pause(0.5)
        
    set(handles.restartButton,'visible','on')
    set(handles.startImpactAnalysisButton,'visible','on')
    set(handles.restartButton,'visible','on')
        
    line{1}='Click START or RESTART to reaquire targets';
    set(handles.promptBox,'string',line)   
     
     %  Update handles structure
        guidata(hObject, handles);    
end

%   #30     startImpactAnalysisButton
function startImpactAnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to startImpactAnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
     set(handles.startImpactAnalysisButton,'visible','off')
     set(handles.restartButton,'visible','off')
     set(handles.tuningLabel,'visible','off')
    
     set(handles.numMarkersDisplay,'visible','off')
     set(handles.numMarkerspopup,'visible','off')
     set(handles.numMarkersLabel,'visible','off')
     
     set(handles.movementSlider,'visible','off')
     set(handles.movementLabel,'visible','off')
     set(handles.movementDisplay,'visible','off')
     set(handles.analyzeButton,'visible','off')
     
     set(handles.maxMarkerSizePopUp,'visible','off')
     set(handles.maxMarkerSizePopUpLabel,'visible','off')
    
     set(handles.markerShapePopup,'visible','off')
     set(handles.markerShapeLabel,'visible','off')
     set(handles.moreLabel,'visible','off')
     set(handles.lessLabel,'visible','off')
     set(handles.directionPopUp,'visible','off')
     set(handles.directionLabel,'visible','off')
    
     set(handles.sampleFreqPopup,'visible','off')
     set(handles.sampleFreqLabel,'visible','off')
     set(handles.filterPopupLabel,'visible','off')
     set(handles.filterFreqPopup,'visible','off')
    
     line{1}='';
     line{2}='HOLD ON, here we go.....';
     set(handles.promptBox,'string',line)
     axes(handles.axes16)
     cla reset
     set(handles.axes16,'visible','off')
     
     
     %% Tracking Section for remaining frames
     %
     %
     %............................................................
     
     %Start the tracking loop
     kountFrame=1;  %Frame 1 is already scanned
     
     %Allow for circular or annular shape in setting of next seed point
     if handles.markerShape==2
         addOn = handles.diameter(jm)*0.35;
     else
         addOn=0;
     end
     
    
     %Start loop for all remaining frames
     for jf=handles.inFrameNumber+1:handles.outFrameNumber;
         kountFrame=kountFrame+1;

         %Display the new frame
         axes(handles.axes1)
         cla reset
         showFrame(:,:)=handles.grayFrame(jf,:,:);
         imshow(showFrame);
         hold on
        
         %Label it
         set(handles.frameNumberDisplay,'string',num2str(jf));
         pause(0.1)
         
         %Set up the RGB Channels for this frame
         redImage=showFrame;
         greenImage=showFrame;
         blueImage=showFrame;
         
         %Start loop for all markers
         for jm=1:handles.numMarkers   
            
            %Draw search area on current frame before proceeding with analysis
            %plot(boxXCO(jm,:),boxYCO(jm,:),'g-')
            
            %Use last centroid as seed for this frame (adjusting for marker shape)
            seedRowGlobal=fix(handles.centroid(jm, kountFrame-1,2)+addOn);
            seedColGlobal=fix(handles.centroid(jm, kountFrame-1,1)); 
                 
            %Plot the seed
            plot(seedColGlobal,seedRowGlobal,'g+');  

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %Region grow the area with a maximum difference of deltaThresh
            %  This is specific for each marker
         
            deltaThresh(jm)=0.2;
            dFrame=im2double(showFrame);
            J = regionGrowing(dFrame,seedRowGlobal,seedColGlobal,deltaThresh(jm),handles.maxMarkerSize);
              
            %Apply the found pixels as a mask to the channels
            redImage(J)=255;
            greenImage(J) = 0;
            blueImage(J) = 0;

            %Concatenate the channels and display
            rgbImage = cat(3, redImage, greenImage, blueImage);

            %Display the colored image
            cla reset
            imshow(rgbImage)
            hold on
            %Wait for fill to show
            pause(0.1)
            
            %Generate a property object for the grown area. 
            %This operates by finding connected regions of 1's
             
            stats = regionprops(J,'all');
            numRegions=numel(stats);
            if numRegions>1
                set(handles.promtBox,'string','Error: More than 1 region found for this marker')
            end
         
            handles.centroid(jm,kountFrame,1)=stats.Centroid(1);
            handles.centroid(jm,kountFrame,2)=stats.Centroid(2);
            pixels(jm)   =  stats.Area;
        
            %Plot the new centroid
            %plot(handles.centroid(jm,1:kountFrame,1),handles.centroid(jm,1:kountFrame,2),'*w');
                        %centroid(jm,jf,row/col)
            %Calculate search box for next frame starting in upper left            
%             diameter(jm) =  stats.EquivDiameter;
%             pixels(jm)   =  stats.Area;
% 
%             side(jm)=diameter(jm)*(1+handles.movementThresh);
%             
%             boxXCO(jm,:) = fix([handles.centroid(jm,jf,1)-side(jm)/2 handles.centroid(jm,jf,1)-side(jm)/2 handles.centroid(jm,jf,1)+side(jm)/2 ...
%                                 handles.centroid(jm,jf,1)+side(jm)/2 ,handles.centroid(jm,jf,1)-side(jm)/2]);
%             boxYCO(jm,:) = fix([handles.centroid(jm,jf,2)-side(jm)/2 handles.centroid(jm,jf,2)+side(jm)/2 handles.centroid(jm,jf,2)+side(jm)/2 ...
%                                 handles.centroid(jm,jf,2)-side(jm)/2 ,handles.centroid(jm,jf,2)-side(jm)/2]);                    
% 
%         
            %Show number of pixels in each marker   
            switch jm
                 case 1
                    set(handles.marker1PIX,'string',num2str(pixels(jm)));
                 case 2
                    set(handles.marker2PIX,'string',num2str(pixels(jm)));               
                 case 3
                    set(handles.marker3PIX,'string',num2str(pixels(jm)));               
                 case 4
                    set(handles.marker4PIX,'string',num2str(pixels(jm)));               
                 case 5
                    set(handles.marker5PIX,'string',num2str(pixels(jm)));
                case 6
                    set(handles.marker6PIX,'string',num2str(pixels(jm)));
            end
         end
     end  
      

%% Transform axes so that movement is left to right and origin is lower left
%      Subscripts for headform markers are handles.headformCentroid(marker,1 for x/2 for y)
%      Subscripts for impact markers   are handles.centroid(marker,frame,1 for x/2 for y)

       %Transform X coordinates
       if handles.directionValue==-1
            handles.calibratedHeadform(:,1) =-handles.headformCentroid(:,1)+handles.numCols;
            handles.calibratedImpact(:,:,1) =-handles.centroid(:,:,1)+handles.numCols;
       end
       
       %Transform y coordinates
       handles.calibratedHeadform(:,2)=-handles.headformCentroid(:,2)+handles.numRows;
       handles.calibratedImpact(:,:,2)=-handles.centroid(:,:,2)+handles.numRows;
       
       if ishandle(7)
           close(7)
       end
       figure(7)
       plot(handles.headformCentroid(1,1),handles.headformCentroid(1,2),'xr')
       hold on
       plot(handles.headformCentroid(2,1),handles.headformCentroid(2,2),'xg')
       plot(handles.headformCentroid(3,1),handles.headformCentroid(3,2),'xb')
       
       plot(handles.calibratedHeadform(1,1),handles.calibratedHeadform(1,2),'or')
       plot(handles.calibratedHeadform(2,1),handles.calibratedHeadform(2,2),'og')
       plot(handles.calibratedHeadform(3,1),handles.calibratedHeadform(3,2),'ob')
       axis equal
       hold off
       
       
%%  Convert raw screen unit to mm
       handles.calibratedHeadform  =handles.calibratedHeadform  * handles.scaleFactor;
       handles.calibratedImpact    =handles.calibratedImpact    * handles.scaleFactor;
               

%% End of Data Acquisition Process
       set(handles.frameNumberDisplay,'string',handles.inFrameNumber)
       set(handles.graphButton,'visible','on')
       set(handles.saveDataButton,'visible','on')
       set(handles.promptBox,'string','Tracking Complete: Click GRAPHS, SAVE, or QUIT')
       set(handles.marker1PIX,'string','')
       set(handles.marker2PIX,'string','')
       set(handles.marker3PIX,'string','')
       set(handles.marker4PIX,'string','')
       set(handles.marker5PIX,'string','')
       set(handles.marker6PIX,'string','')
       
       set(handles.marker1Label,'visible','off')
       set(handles.marker2Label,'visible','off')
       set(handles.marker3Label,'visible','off')
       set(handles.marker4Label,'visible','off')
       set(handles.marker5Label,'visible','off')
       set(handles.marker6Label,'visible','off')
       
     %% Show marker tracks
     
     for jk=1:handles.numMarkers

             x=handles.centroid(jk,:,1);
             y=handles.centroid(jk,:,2);

             plot(x,y,'<r','markerSize',8)

     end
     
    


%%  Close up
    % Update handles structure
    guidata(hObject, handles);    

end

%   %31     movementSlider callback
% --- Executes on slider movement.
function movementSlider_Callback(hObject, eventdata, handles)
% hObject    handle to movementSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    handles.movementThresh=2*get(handles.movementSlider,'value');
    set(handles.movementDisplay,'string',num2str(handles.movementThresh));
    
    % Update handles structure
    guidata(hObject, handles);    

    
end

%   #32     movementSlider CreateFcn
% --- Executes during object creation, after setting all properties.
function movementSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movementSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

%   #33     confirmButton  
% --- Executes on Button press in confirmButton.
function confirmButton_Callback(hObject, eventdata, handles)
% hObject    handle to confirmButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    set(handles.tuningLabel,'visible','on')
    
    set(handles.maxMarkerSizePopUp,'visible','on')
    set(handles.maxMarkerSizePopUpLabel,'visible','on')
       
    set(handles.numMarkersDisplay,'visible','off')
    set(handles.numMarkerspopup,'visible','on')
    set(handles.numMarkersLabel,'visible','on')
     
    set(handles.movementSlider,'visible','on')
    set(handles.movementLabel,'visible','on')
    set(handles.movementDisplay,'visible','on')
    set(handles.analyzeButton,'visible','on')
    
    set(handles.markerShapePopup,'visible','on')
    set(handles.markerShapeLabel,'visible','on')
    set(handles.moreLabel,'visible','on')
    set(handles.lessLabel,'visible','on')
    set(handles.directionPopUp,'visible','on')
    set(handles.directionLabel,'visible','on')
    
    set(handles.sampleFreqPopup,'visible','on')
    set(handles.sampleFreqLabel,'visible','on')
    set(handles.filterPopupLabel,'visible','on')
    set(handles.filterFreqPopup,'visible','on')
    
    set(handles.confirmButton,'visible','off')
    
    set(handles.frameNumberDisplay,'visible','off')
    set(handles.maxFrameDisplay,'visible','off')
    set(handles.playButton,'visible','off')
    set(handles.pauseButton,'visible','off')
    set(handles.backFrameButton,'visible','off')
    set(handles.forwardFrameButton,'visible','off')
    set(handles.fastBackFrameButton,'visible','off')
    set(handles.fastForwardFrameButton,'visible','off')
    set(handles.markIn,'visible','off')
    set(handles.markOut,'visible','off')
    set(handles.inFrameDisplay,'visible','off')
    set(handles.outFrameDisplay,'visible','off')
    
    line{1}='Adjust tuning parameters if needed';
    line{2}='then click Analyze';
    set(handles.promptBox,'string',line)
   
end

%   #34 -   numMarkerspopup_Callback
% --- Executes on selection change in numMarkerspopup.
function numMarkerspopup_Callback(hObject, eventdata, handles)

% hObject    handle to numMarkerspopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns numMarkerspopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from numMarkerspopup

    handles.numMarkers=get(handles.numMarkerspopup,'value')-1;
    set(handles.numMarkersDisplay,'string',num2str(handles.numMarkers));

    % Update handles structure
    guidata(hObject, handles);  
end

%   #35 -   numMarkerspopup_CreateFcn
% --- Executes during object creation, after setting all properties.
function numMarkerspopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numMarkerspopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #36 -   markerShapePopup_Callback
% --- Executes on selection change in markerShapePopup.
function markerShapePopup_Callback(hObject, eventdata, handles)
% hObject    handle to markerShapePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns markerShapePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from markerShapePopu
    
    handles.markerShape=get(handles.markerShapePopup,'value');
    % Update handles structure
    guidata(hObject, handles);
    
end

%   #37 -   markerShapePopup_CreateFcn
% --- Executes during object creation, after setting all properties.
function markerShapePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markerShapePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #38 -   graphButton_Callback
% --- Executes on Button press in graphButton.
function graphButton_Callback(hObject, eventdata, handles)
% hObject    handle to graphButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%  Analyze calibrated data 
%   EITHER from saved data
%   OR from video analysis

%%  Angle and Angular Velocity Calculations and Plots
     
    %Step 1. Express point c2 relative to point c4 for helmet angle
    %        and     point c1 relative to point c5 for headform angle

         %X,Y of point 2 wrt 4 for helmet    
         X1=handles.calibratedImpact(2,:,1)-handles.calibratedImpact(4,:,1);
         Y1=handles.calibratedImpact(2,:,2)-handles.calibratedImpact(4,:,2);
         handles.helmetAngle=atan2(Y1,X1)*57.3; 
              
         %X,Y of point 6 wrt 5 for headform          
         X2=handles.calibratedImpact(6,:,1)-handles.calibratedImpact(5,:,1);
         Y2=handles.calibratedImpact(6,:,2)-handles.calibratedImpact(5,:,2);
         handles.headformAngle=atan2(Y2,X2)*57.3;        
              
         %Express angles relative to zero at first frame
         handles.helmetAngle=handles.helmetAngle-handles.helmetAngle(1);
         handles.headformAngle=handles.headformAngle-handles.headformAngle(1); 
         
%    Apply 4th Order Low Pass Butterworth Filter to Angles
         n=4; %4th order
         fc=handles.filterFrequency;
         fs=handles.sampleFrequency;
         Wn = 2*fc/fs;
         [b,a] = butter(n,Wn);    
                  
         handles.smoothedHelmetAngle  =filtfilt(b,a,handles.helmetAngle);
         handles.smoothedHeadformAngle=filtfilt(b,a,handles.headformAngle);
         
%   Calculate Angular Velocities
         deltaT=1/handles.sampleFrequency;
         handles.deltaT=deltaT;
         handles.helmetOmega  =1/57.3*(diff(handles.smoothedHelmetAngle)/deltaT);
         handles.headformOmega=1/57.3*(diff(handles.smoothedHeadformAngle)/deltaT);

%   Calculate Angular Accelerations
         handles.helmetOmegaDot  =diff(handles.helmetOmega)/deltaT;
         handles.headformOmegaDot=diff(handles.headformOmega)/deltaT; 
         
%%  Generate Time arrays for plots in ms
         
        for jk=(1:size(handles.smoothedHelmetAngle,2))
            handles.angleTime(jk)=(jk-1)*1000*deltaT;
         end
        for jk=(1:size(handles.helmetOmega,2))
            handles.omegaTime(jk)=(jk-1)*1000*deltaT+deltaT/2;
        end  
        for jk=1:size(handles.helmetOmegaDot,2)
            handles.omegaDotTime(jk)=jk*1000*deltaT;
        end
    
      %Test plot
      if ishandle(10)
           close(10)
      end

      figure(10)
      plot(handles.angleTime,handles.smoothedHelmetAngle,'-r')
      hold on
      plot(handles.angleTime,handles.smoothedHeadformAngle,'-b')
      legend('Helmet','Headform')
      title('Angles')
      xlabel('Time (ms)')
      ylabel('Angle (degrees)')
      
      if ishandle(20)
           close(20)
      end  
      
      figure(20)
      plot(handles.omegaTime,handles.helmetOmega,'-r')
      hold on
      plot(handles.omegaTime,handles.headformOmega,'-b')
      legend('Helmet','Headform')      
      title ('Angular Velocities')
      xlabel('Time (ms)')
      ylabel('Angular Velocity (rad/s)')
      
      if ishandle(30)
           close(30)
      end
      figure(30)
      plot(handles.omegaDotTime,handles.helmetOmegaDot,'-r')
      hold on
      plot(handles.omegaDotTime,handles.headformOmegaDot,'-b')
      legend('Helmet','Headform')      
      title ('Angular Accelerations')
      xlabel('Time (ms)')
      ylabel('Angular Acceleration (rad/s^2)')     

%%    Compression Estimate from Calibrated Markers 1 and 3

      a1(:,1)=handles.calibratedImpact(1,:,1);
      a1(:,2)=handles.calibratedImpact(1,:,2);

      a2(:,1)=handles.calibratedImpact(3,:,1);
      a2(:,2)=handles.calibratedImpact(3,:,2); 
     
      handles.compression=sqrt(  (a1(:,1)-a2(:,1)).^2 + (a1(:,2)-a2(:,2)).^2  );
%         
%     %Express relative to baseline
      handles.compression=handles.compression-handles.compressionBaseline;
        
%     %Filter the compression distance
      handles.compression  =filtfilt(b,a,handles.compression);
% 
%     %Calculate rate of compression
      handles.compressionRate= diff(handles.compression); 
%      
      if ishandle(40)
           close(40)
      end
      
      figure(40)                   
      [hAx,hLine1,hLine2]=plotyy(handles.angleTime,handles.compression,handles.omegaTime,handles.compressionRate);
      hold on
      ylabel(hAx(1),'Compression (mm)') 
      ylabel(hAx(2),'Compression Rate (mm/s)')
      xlabel('Time (ms)')
      title('Compression and Compression Rate')
      plot([handles.angleTime(1) handles.angleTime(size(handles.angleTime,2))],[0 0],'r-')
         
%%  Calculate Position Vector of Headform Centroid
    
    %Test plot initial coordinates
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

    %Test plot translated coordinates
    figure(1)
    subplot(1,3,2)
    plot(handles.calibratedHeadform(:,1),handles.calibratedHeadform(:,2),'-x')
    axis equal
    hold on
    plot([0 100],[0 0],'r-','linewidth',2)
    plot([0 0],[0 100],'r-','linewidth',2)
    title('Translated')

    %Rotate by anglee between pts 1 and 3
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
    numFrames=size(handles.calibratedImpact,2);
    for jk=1:numFrames

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

        %% Now translate the rotated Pv and save as pt 7
        pvRotTrans(1)=pvRot(1)+handles.calibratedImpact(6,jk,1);
        pvRotTrans(2)=pvRot(2)+handles.calibratedImpact(6,jk,2);
        handles.calibratedImpact(7,jk,1:2)=pvRotTrans;
              
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

    end
    figure(3)
    for kk=1:numFrames
        X=[handles.calibratedImpact(5,kk,1) handles.calibratedImpact(6,kk,1) handles.calibratedImpact(7,kk,1) handles.calibratedImpact(5,kk,1)];
        Y=[handles.calibratedImpact(5,kk,2) handles.calibratedImpact(6,kk,2) handles.calibratedImpact(7,kk,2) handles.calibratedImpact(5,kk,2)];
        plot(X,Y,'bx-');
        hold on
    end
    

    %% Smooth Headform CoM trajectory (calibratedImpact Point 7)
    for kk=1:numFrames
        handles.headformCOM(kk,:)=handles.calibratedImpact(6,kk,:);
    end
    
    %    Apply 4th Order Low Pass Butterworth Filter to Angles
         n=4; %4th order
         fc=handles.filterFrequency;
         fs=handles.sampleFrequency;
         Wn = 2*fc/fs;
         [b,a] = butter(n,Wn);    
                  
         handles.smoothedheadformCOM(:,1) =filtfilt(b,a,handles.headformCOM(:,1));
         handles.smoothedheadformCOM(:,2) =filtfilt(b,a,handles.headformCOM(:,2));
   
         disp('Hi')
         %Add velocity and acceleration in here
      
       % Update handles structure
       guidata(hObject, handles); 
end

%   #39 -   saveDataButton_Callback
% --- Executes on button press in saveDataButton.
function saveDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %   Saved as follows:
    %       numMarkers      - number of markers
    %       framesToAnalyze - number of frames analyzed
    %       initialTouchDist- touch distance between markers 1 and 2
    %       frameRate       - video frame rate in frames per second
    %       headFormCentroid- handles.headformCentroid(1:3,1:2)
    %       ImpactData      - handles.calibratedData(1:numMarkers,1:numFrames,1:2)
    
    
    %   Set up data
    
    t1=strcat(handles.vidPathName,handles.vidFileName);
    v1=handles.numMarkers;
    v2=handles.framesToAnalyze;
    v3=handles.compressionBaseline;
    v4=handles.sampleFrequency;
    v5=handles.filterFrequency;
    v6=handles.scaleFactor;
    v7=handles.inFrameNumber;
    v8=handles.outFrameNumber;
    
    v9=handles.calibratedHeadform;
    v10=handles.calibratedImpact;

    %   Setup file name
    nameLength =size(handles.vidFileName,2);
    outfileName=strcat(handles.vidFileName(1:nameLength-4),'.txt')
    
    %   Browse to directory
    if size(handles.dataDirectory,2)~=0;
        a= handles.videoDirectory;
        cd(a)
    end
    handles.dataPathName=uigetdir;

    fid=fopen(outfileName,'w'); 
    fprintf(fid,'%60s\n',t1);
    fprintf(fid,'%8.2f %8.2f %8.2f %8.2f %8.2f %8.5f %8i %8i\n',v1,v2,v3,v4,v5,v6,v7,v8);
    fprintf(fid,'%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',v9);
    fprintf(fid,'%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',v10(1:handles.numMarkers,1:handles.framesToAnalyze,1));
    fprintf(fid,'%8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n',v10(1:handles.numMarkers,1:handles.framesToAnalyze,2));
    fclose(fid);  
    
%     %Now save the inframe
%     imageFileName=strcat(handles.vidFileName(1:nameLength-4),'.mat')
%     showFrame(:,:)=handles.grayFrame(handles.inFrameNumber,:,:);
%     save(imageFileName,'showFrame')
    
    %Confirm save to promptBox
    
    lines{1}=['Text datafile: ',outfileName];
    lines{2}='written to directory:'
    lines{3}=a;
    set(handles.promptBox,'string',lines);
    
    %% Update handles structure
    guidata(hObject, handles);
end

%   #38 -   filterPopup_Callback
% --- Executes on selection change in filterFreqPopup.
function filterFreqPopup_Callback(hObject, eventdata, handles)
% hObject    handle to filterFreqPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filterFreqPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterFreqPopup
    freq=get(handles.filterFreqPopup,'value');
    switch freq
        case 1
            handles.filterFrequency=100;
        case 2
            handles.filterFrequency=200;
        case 3
            handles.filterFrequency=300;
    end
    % Update handles structure
    guidata(hObject, handles); 
end

%   #39 -   filterPopup_CreateFcn
% --- Executes during object creation, after setting all properties.
function filterFreqPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterFreqPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #40 -   sampleFreqPopup_Callback
% --- Executes on selection change in sampleFreqPopup.
function sampleFreqPopup_Callback(hObject, eventdata, handles)
% hObject    handle to sampleFreqPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sampleFreqPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sampleFreqPopup

    freq=get(handles.sampleFreqPopup,'value');
    switch freq
        case 1
            handles.sampleFrequency=1000;
        case 2
            handles.sampleFrequency=2000;
        case 3
            handles.sampleFrequency=3200;
    end
    % Update handles structure
    guidata(hObject, handles); 
end

%   #41 -   sampleFreqPopup_CreateFcn
% --- Executes during object creation, after setting all properties.
function sampleFreqPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleFreqPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #42     calLength_callback
function calLength_Callback(hObject, eventdata, handles)
% hObject    handle to calLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calLength as text
%        str2double(get(hObject,'String')) returns contents of calLength as a double
end

%   #43     calLength_CreateFcn
% --- Executes during object creation, after setting all properties.
function calLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #44     directionPopUp_Callback
% --- Executes on selection change in directionPopUp.
function directionPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to directionPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns directionPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from directionPopUp

    value=get(handles.directionPopUp,'value');
    switch value
        case 2
            handles.directionValue=-1;  %Right to left
        case 3
            handles.directionValue=1;   %Left to right
    end
    
    % Update handles structure
    guidata(hObject, handles); 
end

%   #45 directionPopUp_CreateFcn
% --- Executes during object creation, after setting all properties.
function directionPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to directionPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #46 fontSizePopUp_Callback
% --- Executes on selection change in fontSizePopUp.
function fontSizePopUp_Callback(hObject, eventdata, handles)
% hObject    handle to fontSizePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fontSizePopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fontSizePopUp

        handles.fontSizeValue=get(handles.fontSizePopUp,'value');
    
        %% Determine fontsize
        
        value=handles.fontSizeValue;
            switch value
                    case 1
                        handles.fontSize=4;
                    case 2
                        handles.fontSize=6;
                    case 3
                        handles.fontSize=8;
                    case 4
                        handles.fontSize=10;
                    case 5
                        handles.fontSize=12;
           end
        
        
    %% 3.7 Resize fonts of all GUI objects
        size1 =handles.fontSize;
        size15=handles.fontSize*1.5;
        size2 =handles.fontSize*2;
        
%       Make the following x2 fontsize
        set(handles.settingsBackground,'fontsize',size2);

%       Make the following x1.5 fontsize
        set(handles.playButton,'fontsize',size15);
        set(handles.pauseButton,'fontsize',size15);
        set(handles.fastBackFrameButton,'fontsize',size15); 
        set(handles.backFrameButton,'fontsize',size15);
        set(handles.forwardFrameButton,'fontsize',size15);
        set(handles.fastForwardFrameButton,'fontsize',size15);
        set(handles.markIn,'fontsize',size15);
        set(handles.markOut,'fontsize',size15);
        set(handles.inFrameDisplay,'fontsize',size15);
        set(handles.outFrameDisplay,'fontsize',size15);
        set(handles.inFrameDisplay,'fontsize',size15);
        set(handles.saveDataButton,'fontsize',size15);
        set(handles.restartButton,'fontsize',size15);
        set(handles.analyzeButton,'fontsize',size15);
        set(handles.graphButton,'fontsize',size15);
        set(handles.tuningLabel,'fontsize',size15);   
        
%      Make the following x1 fontsize
        set(handles.promptBox,'fontsize',size1);
        set(handles.newDataButton,'fontsize',size1);
        set(handles.readDataButton,'fontsize',size1);
        set(handles.calDistanceLabel,'fontsize',size1);
        set(handles.startHeadformAnalysisButton,'fontsize',size1);
        set(handles.startTouchAnalysisButton,'fontsize',size1);
        set(handles.startImpactAnalysisButton,'fontsize',size1);
        set(handles.loadHeadformVideo,'fontsize',size1);
        set(handles.loadTouchVideo,'fontsize',size1);
        set(handles.loadImpactVideo,'fontsize',size1);
     
        set(handles.directionPopUp,'fontsize',size1);
        set(handles.directionLabel,'fontsize',size1);
        set(handles.maxMarkerSizePopUp,'fontsize',size1);
        set(handles.maxMarkerSizePopUpLabel,'fontsize',size1);
        set(handles.numMarkerspopup,'fontsize',size1);
        set(handles.numMarkersLabel,'fontsize',size1);
        set(handles.markerShapePopup,'fontsize',size1);
        set(handles.markerShapeLabel,'fontsize',size1);
        set(handles.movementSlider,'fontsize',size1);
        set(handles.movementLabel,'fontsize',size1);
        set(handles.lessLabel,'fontsize',size1);
        set(handles.moreLabel,'fontsize',size1);
        set(handles.sampleFreqPopup,'fontsize',size1);
        set(handles.sampleFreqLabel,'fontsize',size1);
        set(handles.filterFreqPopup,'fontsize',size1);
        set(handles.filterPopupLabel,'fontsize',size1);
        set(handles.numMarkersDisplay,'fontsize',size1);
        set(handles.movementDisplay,'fontsize',size1);
        set(handles.quitButton,'fontsize',size1);
        set(handles.settingsButton,'fontsize',size1);
        set(handles.browseToVideoDirectory,'fontsize',size1);
        set(handles.browseToDataDirectory,'fontsize',size1);
        set(handles.marker1PIX,'fontsize',size1);
        set(handles.marker2PIX,'fontsize',size1);
        set(handles.marker3PIX,'fontsize',size1);
        set(handles.marker4PIX,'fontsize',size1);
        set(handles.marker5PIX,'fontsize',size1);
        set(handles.marker6PIX,'fontsize',size1);
        set(handles.marker1Label,'fontsize',size1);
        set(handles.marker2Label,'fontsize',size1);
        set(handles.marker3Label,'fontsize',size1);
        set(handles.marker4Label,'fontsize',size1);
        set(handles.marker5Label,'fontsize',size1);
        set(handles.marker6Label,'fontsize',size1);
        set(handles.videoDirectoryLabel,'fontsize',size1);
        set(handles.dataDirectoryLabel,'fontsize',size1);
        set(handles.videoDirectoryDisplay,'fontsize',size1);
        set(handles.dataDirectoryDisplay,'fontsize',size1);
        set(handles.playButton,'fontsize',size1);
        set(handles.pauseButton,'fontsize',size1);
        set(handles.fontSizeLabel,'fontsize',size1);
        set(handles.fontSizePopUp,'fontsize',size1);
         
        
    % Update handles structure
    guidata(hObject, handles); 
end

%   #47 fontSizePopUp_CreateFcn
% --- Executes during object creation, after setting all properties.
function fontSizePopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fontSizePopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%   #48 plotOptionsPopUp_Callback
% --- Executes on selection change in plotOptionsPopUp.
function plotOptionsPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to plotOptionsPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotOptionsPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotOptionsPopUp

         numFiles=get(handles.plotOptionsPopUp,'value')-1
         
        
         %Set up appData structure for these data in plotting GUI
         setappdata(0,'numFiles',numFiles);
         setappdata(0,'fontSize',handles.fontSize);
         setappdata(0,'longFilename',handles.completeVideoFileName); 
         setappdata(0,'calibratedHeadform',handles.calibratedHeadform);
         setappdata(0,'calibratedImpact',handles.calibratedImpact);
         setappdata(0,'filterFrequency',handles.filterFrequency);
         setappdata(0,'sampleFrequency',handles.sampleFrequency);
         setappdata(0,'inFrame', handles.inFrameNumber);
         setappdata(0,'outFrame',handles.outFrameNumber);
         setappdata(0,'baseline',handles.compressionBaseline);
                
         %Call the plotting GUI
         returnData=plotGUI;
         
         %Wait for plotGUI to close
         waitfor(returnData);
end

%   #49 plotOptionsPopUp_CreateFcn
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

