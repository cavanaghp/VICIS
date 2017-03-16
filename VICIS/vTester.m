    %vtester.m
    
    clc
    clear all
    close all
    
    %%  Browse to video file and read it
    cd '/Users/cavanagh/Documents/VICIS/Videos';
    handles.vidPathName='/Users/cavanagh/Dropbox/Riddell Speedflex Video_PC';
    handles.vidFileName='2016.01.19_Riddell Speedflex_90 deg_PC.mp4';
    file=[handles.vidPathName,'/',handles.vidFileName]; 
    vidObj=VideoReader(file);
    
        %Read RGB Frame
        rgb = readFrame(vidObj);
        figure(1)
        imshow(rgb);
        
        %Convert to gray scale
        gray  = rgb2gray(rgb);
        figure(2)
        imshow(gray);
        
        %create channels which are copies of original grey scale image
        redImage=gray;
        greenImage=gray;
        blueImage=gray;
     
        %make a mask of bright pixels    
        brightPixels = gray>250;
  
        %Apply the mask to the channels
        redImage(brightPixels)=255;
        greenImage(brightPixels) = 0;
        blueImage(brightPixels) = 0;
     
        % Combine into a new RGB image.
        rgbImage = cat(3, redImage, greenImage, blueImage);
        
        %Display the image
        figure (3)
        imshow(rgbImage)
     