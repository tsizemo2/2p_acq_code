% make_positionFunctions_YEF
 
%% STATIC array for when you don't want the other channel to move

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

positionArray = zeros(1, POSITION_FUNCTION_LENGTH);

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_001_Static0']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 %% 2 Second alternative flashes ON or OFF
% 0000000 11111111 (2 sec) 000000000 (2 sec)

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

FLASH_DURATION = 2; % seconds

% Warning zero indexing for the positino funciton!!
YDim1 = 0;% displays full dark screen, (dim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 2;% displays full light screen (dim =3), if this is zero indexing now... which i think it should be for position functions

positionArray = [];
switchingCounter = true;

while (length (positionArray) < POSITION_FUNCTION_LENGTH)
    % segement of flash to be added
    currFlashSegment = ones(1, FLASH_DURATION * PANELS_FRAME_RATE);
    
    % YVETTE: findout the quick way to do this in matlab!!?
    if(switchingCounter)
        
        positionArray = [ positionArray,  YDim1 * currFlashSegment ];
        switchingCounter = false;
    else
        positionArray = [ positionArray,  YDim2 * currFlashSegment ];
        switchingCounter = true;
    end
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_002_FFF']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
 %% 100 ms OFF dark flash, 2 sec ON interleave
FLASH_DURATION = .1; % seconds, 100ms
INTER_FLASH_DURATION = 1.9; % seconds
% Warning zero indexing for the positino funciton!!
YDim1 = 0;% displays full dark screen, (dim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 2;% displays full light screen (dim =3), if this is zero indexing now... which i think it should be for position functions

positionArray = [];
switchingCounter = true;

while (length (positionArray) < POSITION_FUNCTION_LENGTH)

    if(switchingCounter)
        % build interflash period and add it to the position array
        currFlashSegment = YDim2 * ones(1, INTER_FLASH_DURATION * PANELS_FRAME_RATE);
        positionArray = [ positionArray,  currFlashSegment ];
        switchingCounter = false;
        
    else
        % build flash period and add it to the position array
        currFlashSegment = YDim1 * ones(1, FLASH_DURATION * PANELS_FRAME_RATE);
        positionArray = [ positionArray,   currFlashSegment ];
        switchingCounter = true;
    end
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_003_100msOFF']; 	% name must begin with ‘Pattern_’
 save(str, 'func');

 %% 100 ms ON flashes, 2 sec OFF interleave
FLASH_DURATION = .1; % seconds, 100ms
INTER_FLASH_DURATION = 1.9; % seconds

% Warning zero indexing for the positino funciton!!
YDim1 = 0;% displays full dark screen, (dim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 2;% displays full light screen (dim =3), if this is zero indexing now... which i think it should be for position functions

positionArray = [];
switchingCounter = true;

while (length (positionArray) < POSITION_FUNCTION_LENGTH)

    if(switchingCounter)
        % build interflash period and add it to the position array
        currFlashSegment = YDim1 * ones(1, INTER_FLASH_DURATION * PANELS_FRAME_RATE);
        positionArray = [ positionArray,  currFlashSegment ];
        switchingCounter = false;
        
    else
        % build flash period and add it to the position array
        currFlashSegment = YDim2 * ones(1, FLASH_DURATION * PANELS_FRAME_RATE);
        positionArray = [ positionArray,   currFlashSegment ];
        switchingCounter = true;
    end
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_004_100msFlashON']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
 %% 2 sec OFF flashes, 2 sec Grading/pattern interleave
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

FLASH_DURATION = 2; % seconds

% Warning zero indexing for the position funciton!!
YDim1 = 0;% displays full dark screen, (ydim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 1;% displays gratting (ydim =3), if this is zero indexing now... which i think it should be for position functions

positionArray = [];
switchingCounter = true;

while (length (positionArray) < POSITION_FUNCTION_LENGTH)
    % segement of flash to be added
    currFlashSegment = ones(1, FLASH_DURATION * PANELS_FRAME_RATE);
    
    % YVETTE: findout the quick way to do this in matlab!!?
    if(switchingCounter)
        
        positionArray = [ positionArray,  YDim1 * currFlashSegment ];
        switchingCounter = false;
    else
        positionArray = [ positionArray,  YDim2 * currFlashSegment ];
        switchingCounter = true;
    end
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_005_VertGrat']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 %% 6: 2 sec OFF flashes, 2 sec Grading/pattern interleave
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

FLASH_DURATION = 2; % seconds

% Warning zero indexing for the positino funciton!!
YDim1 = 2;% displays full light (ON) screen, (ydim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 1;% displays pattern (ydim =2)

positionArray = [];
switchingCounter = true;

while (length (positionArray) < POSITION_FUNCTION_LENGTH)
    % segement of flash to be added
    currFlashSegment = ones(1, FLASH_DURATION * PANELS_FRAME_RATE);
    
    % YVETTE: findout the quick way to do this in matlab!!?
    if(switchingCounter)
        
        positionArray = [ positionArray,  YDim1 * currFlashSegment ];
        switchingCounter = false;
    else
        positionArray = [ positionArray,  YDim2 * currFlashSegment ];
        switchingCounter = true;
    end
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_006_2secON_2secPattern']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
  %% ~15Deg/s RIGHTWARD Motion either Gratting or bar:
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while (length (positionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter <= XDimMax)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
    % currFrameCounter = mod( currFrameCounter , XDimMax );% don't excced XDimMax
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

 
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_007_rightwardPatternMotion_15degS']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 %% ~75Deg/s RIGHTWARD Motion either Gratting or bar:
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up

PATTERN_SPEED_DEG_PER_SEC = 75;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while (length (positionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter <= XDimMax)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
    %currFrameCounter = mod( currFrameCounter , XDimMax );% don't excced XDimMax
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

 
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_009_rightwardPatternMotion_75degS']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 %% ~15Deg/s LEFTWARD Motion either Gratting or bar:
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMax - 1;
while (length (positionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter > XDimMin)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter - 1;
    %currFrameCounter = mod( currFrameCounter , XDimMax);% don't excced XDimMax
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;
 
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_008_leftwardPatternMotion_15degS']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
  %% ~75Deg/s LEFTWARD Motion either Gratting or bar:
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up

PATTERN_SPEED_DEG_PER_SEC = 75;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMax - 1;
while (length (positionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter > XDimMin)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter - 1;
    %currFrameCounter = mod( currFrameCounter , XDimMax);% don't excced XDimMax
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;
 
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_010_leftwardPatternMotion_75degS']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
 %% STATIC PATTERN (y) array for when you don't want the other channel to move

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

positionArray = ones(1, POSITION_FUNCTION_LENGTH);

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_011_Static1_pattern']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 %% BAR at RANDOM LOCATION
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
FLASH_DURATION = 0.5; % seconds
BETWEEN_FLASH_DURATION = 0.5; % seconds

numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

NUM_POSSIBLE_BAR_POSITIONS = 27; % 1 to 54 by steps of 2... since the bar is 2 pixels thick
% Build the array of random sample location order
BLANK_DIM = 56 - 1;

positionOrder = [];

NUM_REPs = 5; % number of times this will cycle thru different random order of bar locations
for i = 1: NUM_REPs 
    
positionOrder = [positionOrder; randsample( NUM_POSSIBLE_BAR_POSITIONS , NUM_POSSIBLE_BAR_POSITIONS ) ]; % without replacements

end

% 1:1:27 -> 2:2:54 steps of two
positionOrder = positionOrder* 2;

positionArray = [];

for j = 1: length( positionOrder )
    barPeriod = positionOrder(j)* ones(1, FLASH_DURATION * PANELS_FRAME_RATE );  
    blankPeriod = BLANK_DIM * ones(1, BETWEEN_FLASH_DURATION * PANELS_FRAME_RATE )   ; % 1 sec of some position
    
    positionArray = [positionArray barPeriod blankPeriod];
end 

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_012_barRandLocVert']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
%% 0.5 sec OFF flashes, 0.5 sec Pattern 
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

FLASH_DURATION = 0.5; % seconds

% Warning zero indexing for the position funciton!!
YDim1 = 0;% displays full dark screen, (ydim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 1;% displays gratting (ydim =3), if this is zero indexing now... which i think it should be for position functions

positionArray = [];
switchingCounter = true;

while (length (positionArray) < POSITION_FUNCTION_LENGTH)
    % segement of flash to be added
    currFlashSegment = ones(1, FLASH_DURATION * PANELS_FRAME_RATE);
    
    % YVETTE: findout the quick way to do this in matlab!!?
    if(switchingCounter)
        
        positionArray = [ positionArray,  YDim1 * currFlashSegment ];
        switchingCounter = false;
    else
        positionArray = [ positionArray,  YDim2 * currFlashSegment ];
        switchingCounter = true;
    end
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_013_halfSecOFFhalfSecPattern']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
%% IPSILATERAL BAR at RANDOM LOCATION
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
FLASH_DURATION = 0.5; % seconds
BETWEEN_FLASH_DURATION = 0.5; % seconds

numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

NUM_POSSIBLE_BAR_POSITIONS = 1: 2: 39;% 10: 2: 34; % 10 to 34 by steps of 2... since the bar is 2 pixels thick
% Build the array of random sample location order
BLANK_DIM = 56 - 1;

positionOrder = [];

NUM_REPs = 10; % number of times this will cycle thru different random order of bar locations
for i = 1: NUM_REPs 
    
positionOrder = [positionOrder, randsample( NUM_POSSIBLE_BAR_POSITIONS , numel(NUM_POSSIBLE_BAR_POSITIONS) ) ]; % without replacements

end

% % 1:1:27 -> 2:2:54 steps of two
% positionOrder = positionOrder* 2;

positionArray = [];

for j = 1: length( positionOrder )
    barPeriod = positionOrder(j)* ones(1, FLASH_DURATION * PANELS_FRAME_RATE );  
    blankPeriod = BLANK_DIM * ones(1, BETWEEN_FLASH_DURATION * PANELS_FRAME_RATE )   ; % 1 sec of some position
    
    positionArray = [positionArray barPeriod blankPeriod];
end 


func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_014_IPSI_barRandLocVert']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
%% 2 sec OFF flashes, 60 sec pattern interleave
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

PRE_FLASH_DURATION = 2; % seconds
FLASH_DURATION = 60; % seconds

% Warning zero indexing for the position funciton!!
YDim1 = 0;% displays full dark screen, (ydim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 1;% displays gratting (ydim =3), if this is zero indexing now... which i think it should be for position functions

preFlashSegment = ones(1, PRE_FLASH_DURATION * PANELS_FRAME_RATE);
flashSegment = ones(1, FLASH_DURATION * PANELS_FRAME_RATE);

positionArray = [ YDim1*preFlashSegment YDim2*flashSegment  YDim1*preFlashSegment];


func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_015_60secPattern']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
 
%% Randomly interveaved contrast values of a bar:  build a function for y-pos that will scale thru the different contrast
% keep x position static (1?)
% levels ... 2, 4, 5, 6, 7 ,8 ,9.....  random interleave..
NUM_POSSIBLE_BAR_CONTRASTS = 1:7; % on LED board
MAPPING_CON_TO_YDim = [2 4 5 6 7 8 9]; % the y dims that correspond to these values
MAPPING_CON_TO_YDim = MAPPING_CON_TO_YDim - 1; % account for zero indexing in pos function

BLANK_DIM = 1 - 1; % "blank" aka all black, no LEDs on.

PANELS_FRAME_RATE = 50; %Hz
FLASH_DURATION = 0.5; % seconds
BETWEEN_FLASH_DURATION = 0.5; % seconds

contrastOrder = [];

NUM_REPs = 10; % number of times this will cycle thru different random order of bar contrast levels
for i = 1: NUM_REPs 
    
contrastOrder = [contrastOrder, randsample( NUM_POSSIBLE_BAR_CONTRASTS , numel(NUM_POSSIBLE_BAR_CONTRASTS) ) ]; % without replacements

end

yDimArray = [];

for j = 1: length( contrastOrder )
    
    currConstast = contrastOrder(j);
    
    barPeriod =   MAPPING_CON_TO_YDim(currConstast)* ones(1, FLASH_DURATION * PANELS_FRAME_RATE );  
    blankPeriod = BLANK_DIM * ones(1, BETWEEN_FLASH_DURATION * PANELS_FRAME_RATE )   ; % 1 sec of some position
    
    yDimArray = [yDimArray barPeriod blankPeriod];
end 


func = yDimArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_016_randBarContrastLevels']; 	% name must begin with ‘Pattern_’
 save(str, 'func');

 
%% Randomly interveaved ON Bar widths!
% keep x position static (1?)
% levels ...1: 7
NUM_POSSIBLE_BAR_WIDTHS = 1:7; % on LED board

PANELS_FRAME_RATE = 50; %Hz
FLASH_DURATION = 1; % seconds
BETWEEN_FLASH_DURATION = 1; % seconds

BLANK_DIM = 1 - 1; % "blank" aka all black, no LEDs on.

widthOrder = [];

NUM_REPs = 10; % number of times this will cycle thru different random order of bar contrast levels
for i = 1: NUM_REPs 
    
widthOrder = [widthOrder, randsample( NUM_POSSIBLE_BAR_WIDTHS , numel(NUM_POSSIBLE_BAR_WIDTHS) ) ]; % without replacements

end

yDimArray = [];

for j = 1: length( widthOrder )
    
    currWidth = widthOrder(j) - 1;
    
    barPeriod =   currWidth* ones(1, FLASH_DURATION * PANELS_FRAME_RATE );  
    blankPeriod = BLANK_DIM * ones(1, BETWEEN_FLASH_DURATION * PANELS_FRAME_RATE )   ; % 1 sec of some position
    
    yDimArray = [yDimArray barPeriod blankPeriod];
end 


func = yDimArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_017_randBarWidth']; 	% name must begin with ‘Pattern_’
 save(str, 'func');

%%  Interleaved moving bar stimulus
% 20 sec blank, bar light, bar left repeat   (have the y dim postion
% control the ON 10 sec period during the 20 starting time

% funciton handle the ON and OFF parts
NO_MOTION_PERIOD = 20; % seconds
BLANK_DIM = 56 - 1; % where not bar is drawn

PANELS_FRAME_RATE = 50; %Hz
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross - 1;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


% add blank time before the bar moves for full screen ON and OFF:
blankTime = BLANK_DIM*ones(1, PANELS_FRAME_RATE * NO_MOTION_PERIOD);
positionArray = [positionArray blankTime ];

% add bar moving right
currFrameCounter = XDimMin;
while (currFrameCounter <= XDimMax)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
    % currFrameCounter = mod( currFrameCounter , XDimMax );% don't excced XDimMax
      
end

% add bar moving left
currFrameCounter = XDimMax;
while (currFrameCounter >= XDimMin)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter - 1;
    % currFrameCounter = mod( currFrameCounter , XDimMax );% don't excced XDimMax
      
end

func = positionArray;

%% position function 19- 10 sec of screen ON aligned timing with position function 18
DURATION_OF_WHOLE_FUNCTION = numel(func); 
ON_PERIOD = 10; %seconds
PANELS_FRAME_RATE = 50; %Hz

PATTERN_DIM = 2 - 1;
ON_DIM = 3 - 1;

array = PATTERN_DIM * ones (1, DURATION_OF_WHOLE_FUNCTION);

array( 1: ON_PERIOD * PANELS_FRAME_RATE)  = ON_DIM;

func2 = array;
 

%% position function 20- 10 sec of screen OFF aligned timing with position function 18
DURATION_OF_WHOLE_FUNCTION = numel(func); 
OFF_PERIOD = 10; %seconds
PANELS_FRAME_RATE = 50; %Hz

PATTERN_DIM = 2 - 1;
OFF_DIM = 1 - 1;

array = PATTERN_DIM * ones (1, DURATION_OF_WHOLE_FUNCTION);

array( 1: OFF_PERIOD * PANELS_FRAME_RATE)  = OFF_DIM;

func3 = array;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_018_pauseStripeONRightLeft']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_019_10secScreenONFlash']; 	% name must begin with ‘position_function’
 func = func2;
 save(str, 'func');

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_020_10secScreenOFF']; 	% name must begin with ‘position_function’
 func = func3;
 save(str, 'func');

 %% 10 Second alternative flashes ON or OFF
% 0000000 11111111 (10 sec) 000000000 (10 sec)

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels

FLASH_DURATION = 10; % seconds

% Warning zero indexing for the positino funciton!!
YDim1 = 0;% displays full dark screen, (dim = 1) if this is zero indexing now... which i think it should be for position functions
YDim2 = 2;% displays full light screen (dim =3), if this is zero indexing now... which i think it should be for position functions

positionArray = [];
switchingCounter = true;

while (length (positionArray) < POSITION_FUNCTION_LENGTH)
    % segement of flash to be added
    currFlashSegment = ones(1, FLASH_DURATION * PANELS_FRAME_RATE);
    
    % YVETTE: findout the quick way to do this in matlab!!?
    if(switchingCounter)
        
        positionArray = [ positionArray,  YDim1 * currFlashSegment ];
        switchingCounter = false;
    else
        positionArray = [ positionArray,  YDim2 * currFlashSegment ];
        switchingCounter = true;
    end
      
end

% cut off any frames past the end of POSITION_FUNCTION_LENGTH
if (length (positionArray) > POSITION_FUNCTION_LENGTH)
    disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
    positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
end

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_021_FFF10sec']; 	% name must begin with ‘position_function’
 save(str, 'func');
%% FAST moving 2 pixel dot that touches every point on the screen
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

DOT_WIDTH = 2; % number of LED dots wide
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up


func = 1: LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % 

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_022_fastSweeping2PixelDot']; 	% name must begin with ‘position_function’
 save(str, 'func');
 
 %% FAST moving dot 4 pixel that touches every point on the screen
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

DOT_WIDTH = 4; % number of LED dots wide
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up


func = 1: LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % 

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_023_fastSweeping4PixelDot']; 	% name must begin with ‘position_function’
 save(str, 'func');
 
 
%% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % ;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_024_Sweeping2PixelDot_15degS']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 %% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 4;

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % ;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
    
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_025_Sweeping4PixelDot_15degS']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
%% WHOLE SCREEN RANDOM DOT LOCATION
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
FLASH_DURATION = 0.5; % seconds
BETWEEN_FLASH_DURATION = 0.5; % seconds

DOT_WIDTH = 2; % LEDs wide

numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % 


vectorOFPossibleDotPositions = [];

for ypos = 1 : 2 : ( LEDdotsVertically - ( DOT_WIDTH - 1))
       for xpos = 1 : 2 : ( LEDdotsAcross - ( DOT_WIDTH - 1))
           
           currDotPos = ( ( ypos - 1)  * LEDdotsAcross)  +  xpos;
           vectorOFPossibleDotPositions = [ vectorOFPossibleDotPositions currDotPos];
       end
end

% last position of the final array in this pattern
BLANK_DIM = LEDdotsAcross;

positionOrder = [];

NUM_REPs = 5; % number of times this will cycle thru different random order of bar locations
for i = 1: NUM_REPs 
    
positionOrder = [positionOrder vectorOFPossibleDotPositions( randperm( numel(vectorOFPossibleDotPositions)  )) ]; % without replacements

end

positionArray = [];

for j = 1: length( positionOrder )
    barPeriod = positionOrder(j)* ones(1, FLASH_DURATION * PANELS_FRAME_RATE );  
    blankPeriod = BLANK_DIM * ones(1, BETWEEN_FLASH_DURATION * PANELS_FRAME_RATE )   ; % 1 sec of some position
    
    positionArray = [positionArray barPeriod blankPeriod];
end 

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_026_dotRandLoc']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
%% IPSI LATERAL VIEW  RANDOM DOT LOCATION
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
FLASH_DURATION = 0.5; % seconds
BETWEEN_FLASH_DURATION = 0.5; % seconds

DOT_WIDTH = 2; % LEDs wide

numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

xposMin = 1;
xposMax = 39; % LED position at midline
yposMin = 1;
yposMax = LEDdotsVertically - ( DOT_WIDTH - 1);  % LED panels position

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % 


vectorOFPossibleDotPositions = []; % 160 posible locations

for ypos = yposMin : 2 : yposMax
       for xpos = xposMin: 2 : xposMax
           
           currDotPos = ( ( ypos - 1)  * LEDdotsAcross)  +  xpos;
           vectorOFPossibleDotPositions = [ vectorOFPossibleDotPositions currDotPos];
       end
end

% last position of the final array in this pattern
BLANK_DIM = LEDdotsAcross;% - 1;

positionOrder = [];

NUM_REPs = 5; % number of times this will cycle thru different random order of bar locations
for i = 1: NUM_REPs 
    
positionOrder = [positionOrder vectorOFPossibleDotPositions( randperm( numel(vectorOFPossibleDotPositions)  )) ]; % without replacements

end

positionArray = [];

for j = 1: length( positionOrder )
    barPeriod = positionOrder(j)* ones(1, FLASH_DURATION * PANELS_FRAME_RATE );  
    blankPeriod = BLANK_DIM * ones(1, BETWEEN_FLASH_DURATION * PANELS_FRAME_RATE )   ; % 1 sec of some position
    
    positionArray = [positionArray barPeriod blankPeriod];
end 

func = positionArray;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_027_dotRandLocIpsi']; 	% name must begin with ‘Pattern_’
 save(str, 'func');

%% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 1
elevation = 1;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_028_Sweeping2PixelDot_15degS_Elev1']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
%% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 2
elevation = 2;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_029_Sweeping2PixelDot_15degS_Elev2']; 	% name must begin with ‘Pattern_’
 save(str, 'func');

%% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 3
elevation = 3;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_030_Sweeping2PixelDot_15degS_Elev3']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
%% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 4
elevation = 4;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_031_Sweeping2PixelDot_15degS_Elev4']; 	% name must begin with ‘Pattern_’
 save(str, 'func');

%% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 5
elevation = 5;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_032_Sweeping2PixelDot_15degS_Elev5']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
 
 %% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 6
elevation = 6;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_033_Sweeping2PixelDot_15degS_Elev6']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
  %% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 7
elevation = 7;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_034_Sweeping2PixelDot_15degS_Elev7']; 	% name must begin with ‘Pattern_’
 save(str, 'func');
 
  %% ~15Deg/s RIGHTWARD Motion for a 2 LED wide pixel DOT
% ELEVATION = 8
elevation = 8;

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg %CHECK!  THIS IS APPROXIMATE!!
DOT_WIDTH = 2;

% Warning zero indexing for the position funciton!!
XDimMin = 2*(elevation - 1)*LEDdotsAcross   + 1;
XDimMax = (2*(elevation - 1)*LEDdotsAcross ) + LEDdotsAcross;

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )


currFrameCounter = XDimMin;
while currFrameCounter <= XDimMax 
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );
    %linearArrayToAdd = XDimMin:XDimMax;
    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;
end

func = positionArray;
 %% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\functions\';
 str = [directory_name '\position_function_035_Sweeping2PixelDot_15degS_Elev8']; 	% name must begin with ‘Pattern_’
 save(str, 'func');