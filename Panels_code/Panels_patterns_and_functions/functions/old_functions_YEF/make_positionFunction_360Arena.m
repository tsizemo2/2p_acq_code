%make_positionFunction_360Arena

%%  Interleaved moving bar stimulus 50 deg/s
PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 12;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 96 for yvette's set up including fictive panels

PATTERN_SPEED_DEG_PER_SEC = 50;% deg/s  
DEGREES_PRE_PIXEL = 3; % ~deg

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

rightwardPositionArray = [];
leftwardPositionArray = [];

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )

%Build Rightward segement of array:
currFrameCounter = XDimMin;
while (length (rightwardPositionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter <= XDimMax)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );

    rightwardPositionArray = [rightwardPositionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;     
end

%Build leftward segement of array:
currFrameCounter = XDimMax - 1;
while (length (leftwardPositionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter > XDimMin)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );

    leftwardPositionArray = [leftwardPositionArray addToArray ];
    
    currFrameCounter = currFrameCounter - 1;  
end

NUM_TIMES_TO_REPEAT_GRATING_ROTAION = 5;
func = [ repmat( rightwardPositionArray , 1, NUM_TIMES_TO_REPEAT_GRATING_ROTAION)  repmat( leftwardPositionArray , 1, NUM_TIMES_TO_REPEAT_GRATING_ROTAION) ];

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\functions\';
 str_x = [directory_name '\position_function_015_movingGratingRightLeft_50degS']; 
 save(str_x, 'func'); % variable must be named 'func'

  %% Position function 19, x  postion values FAST 250 ms barRandLoc stimulus NO BREAK!
% build position function for the bar at random position stimulus
% build xpos 
PANELS_FRAME_RATE = 50; %Hz
FLASH_DURATION = 0.250; % approximately **** 250 mseconds
BETWEEN_FLASH_DURATION = 0; % seconds

numOfPanelsIncludingFictive = 12;

numOfPanelsAcross = 9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

xposMin = 1;
xposMax = LEDdotsAcross - 2; % subtract 1 + 1 b/c controller add this to starting position which is default to 1 and so not to sample blank dim

% build 2 arrays that together would sample every other location in a 16X56 matrix
xpossPosition = xposMin : 2 : xposMax; 

xpositionOrder = [];

NUM_REPs = 5; % number of times this will cycle thru different random order of dot locations
for i = 1: NUM_REPs 
    
    currRandomOrder = randperm( numel(xpossPosition) );
    
    % add another round of rand values to x pos order
    xpositionOrder = [xpositionOrder xpossPosition( currRandomOrder ) ]; % without replacements
end

% build actual positionFunction
xpositionFunction = [];

% last position of the final array in this pattern
BLANK_DIM_X = (numOfPanelsIncludingFictive * LEDdotsPerPanel) - 1;% subtract 1 b/c controller add this to starting position which is default to 1.

for j = 1: length( xpositionOrder )
    barPeriod_X = xpositionOrder(j)* ones(1, round( FLASH_DURATION * PANELS_FRAME_RATE ) );   
    
    % blankPeriod_X = BLANK_DIM_X * ones(1, BETWEEN_FLASH_DURATION * PANELS_FRAME_RATE ); % 
    
    xpositionFunction = [xpositionFunction barPeriod_X ];
end 

func = xpositionFunction;

%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\functions\';
 str_x = [directory_name '\position_function_019_barRandLoc_250ms_Xpos']; 
 save(str_x, 'func'); % variable must be named 'func'
 %%
  %% PHASE OFFSET 1:: Ofsted pattern 270 deg world 
clear all;
numOfPanelsAcross = 9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;

pattern.num_panels = 18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

%Create a single "ghost" LED column but include an extra column in the
%pattern and then removing it at the end of the 
Pats = zeros(LEDdotsVertically, LEDdotsAcross + 1, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Matrix of initial pattern: Ofstad 2011 inspried pattern
initialPattern = [1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1;1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0];

PHASE_SHIFT_AMOUNT = 0; % LED pixel number to shift rightward by
% Shift pattern by desired offset
initialPattern_shifted = circshift( initialPattern, PHASE_SHIFT_AMOUNT, 2);

for xpos = 1: LEDdotsAcross + 1 % - ( BAR_WIDTH - 1)
    
    % shift dot_pattern to each different location depending on current
    % x pos
    Pats(:, :, xpos , 1) = ShiftMatrix (initialPattern_shifted, (xpos - 1),'r','y'); % place
end
% trim sigle "Ghost" LED collumn out of the pattern and pattern dimentions since it will confuse
% the panels system"
Pats = Pats(:, 1:LEDdotsAcross, 1:LEDdotsAcross , :);
pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 270 degree arena updated 10/25/17 define panel structure vector
%pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_026_OfstadPattern_phase1']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');