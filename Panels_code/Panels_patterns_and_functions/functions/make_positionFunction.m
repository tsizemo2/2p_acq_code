%% make_positionFunctions


% ~15Deg/s RIGHTWARD Motion either Grating or bar:
PANELS_FRAME_RATE = 200; %Hz
POSITION_FUNCTION_LENGTH = 10000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 12;% 
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg THIS IS APPROXIMATE and wrong!!

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross - 1;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )

currFrameCounter = XDimMin;
while (length (positionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter <= XDimMax)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );

    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;     
end


func = positionArray;
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Panels_patterns_and_functions\functions';
 str_x = [directory_name '\position_function_001_movingRightPattern_15degS']; 
 save(str_x, 'func'); % variable must be named 'func'

 %% ~15Deg/s LEFTWARD Motion either Gratting or bar:
PANELS_FRAME_RATE = 200; %Hz
POSITION_FUNCTION_LENGTH = 10000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 12;% panels across
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

currFrameCounter = XDimMax - 1;
while (length (positionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter > XDimMin)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );

    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter - 1;  
end

func = positionArray;
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name ='C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Panels_patterns_and_functions\functions\';
 str_x = [directory_name '\position_function_002_movingLeftPattern_15degS']; 
 save(str_x, 'func'); % variable must be named 'func'
 
%%

% Static position
PANELS_FRAME_RATE = 200; %Hz
POSITION_FUNCTION_LENGTH = 10000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 12;% 
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg THIS IS APPROXIMATE and wrong!!

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

    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;     
end

positionArray(1:end) = 0;
func = positionArray;
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Panels_patterns_and_functions\functions';
 str_x = [directory_name '\position_function_003_static']; 
 save(str_x, 'func'); % variable must be named 'func'
 
 %% Test pattern
TEST_DUR = 10 % Duration of test pattern in seconds
PANELS_FRAME_RATE = 200; %Hz
POSITION_FUNCTION_LENGTH = PANELS_FRAME_RATE * TEST_DUR; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 12;% 
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 
LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 

positionsPerSec = floor(LEDdotsAcross / TEST_DUR);
positionArray = [];
for iSec = 1:TEST_DUR
    startPos = 1 + ((iSec - 1) * (PANELS_FRAME_RATE));
    endPos = startPos + PANELS_FRAME_RATE - 1;
    positionArray(startPos:endPos) = iSec * positionsPerSec;
end

func = positionArray;
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Panels_patterns_and_functions\functions';
 str_x = [directory_name '\position_function_004_testPattern']; 
 save(str_x, 'func'); % variable must be named 'func'
 