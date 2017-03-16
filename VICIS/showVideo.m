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

