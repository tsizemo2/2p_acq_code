%make_visual_Patterns_PositionFunctions_YEF

%% Vertical Gratting Pattern  4 pixels wide
% Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 


LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 2;
gratingWidth = 4;
grating = zeros( 1 , LEDdotsAcross);

for i = 1: LEDdotsAcross  
    if( mod( i , gratingWidth * 2) < ( gratingWidth ) )
        grating(i) = 1; % add in light stripes at each of these locations
    end
end

stripe_pattern = repmat ( grating, LEDdotsVertically,  1); % extend matrix to include the whole vertical extent of the panels

Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;

for j = 2:LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
    Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:,j-1,PATTERN_INDEX),1,'r','y');
end


% Make the whole matrix of y = 3 LEDs all ON
ONIndex = 3;
Pats(:, : , :, ONIndex) = 1;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

%% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_001_grating_4pixelWide']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 %% Make Position Functions:
 
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
 
 
 %% Vertical Stripe DARK
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 2;
gratingWidth = 4;
grating = zeros( 1 , LEDdotsAcross);

for i = 1: LEDdotsAcross  
    if( mod( i , gratingWidth * 2) < ( gratingWidth ) )
        grating(i) = 1; % add in light stripes at each of these locations
    end
end

% make initial stripe pattern zero = dark, one = light
stripe_pattern = [zeros( LEDdotsVertically, STRIPE_WIDTH ), ones( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;

for j = 2 : LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
    Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
end


% Make the whole matrix of y = 3 LEDs all ON
ONIndex = 3;
Pats(:, : , :, ONIndex) = 1;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_002_stripeVert2pixelDark']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
 %% Vertical Stripe LIGHT ON
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 2;
gratingWidth = 4;
grating = zeros( 1 , LEDdotsAcross);

for i = 1: LEDdotsAcross  
    if( mod( i , gratingWidth * 2) < ( gratingWidth ) )
        grating(i) = 1; % add in light stripes at each of these locations
    end
end

% make initial stripe pattern one = light and background  zero = dark, 
stripe_pattern = [ones( LEDdotsVertically, STRIPE_WIDTH ), zeros( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;

for j = 2 : LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
    Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
end


% Make the whole matrix of y = 3 LEDs all ON
ONIndex = 3;
Pats(:, : , :, ONIndex) = 1;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_003_stripeVert2pixelBright']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');

 %% Vertical Stripe LIGHT ON
 % with last 56 dimention blank
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 2;
gratingWidth = 4;
grating = zeros( 1 , LEDdotsAcross);

for i = 1: LEDdotsAcross  
    if( mod( i , gratingWidth * 2) < ( gratingWidth ) )
        grating(i) = 1; % add in light stripes at each of these locations
    end
end

% make initial stripe pattern one = light and background  zero = dark, 
stripe_pattern = [ones( LEDdotsVertically, STRIPE_WIDTH ), zeros( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;

for j = 2 : LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
    Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
end

% make last dimention blank black screen 56
Pats(:,:,LEDdotsAcross, PATTERN_INDEX) = zeros( LEDdotsVertically , LEDdotsAcross );

% Make the whole matrix of y = 3 LEDs all ON
ONIndex = 3;
Pats(:, : , :, ONIndex) = 1;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_004_stripeVert2pixelBright_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
 %% Vertical Stripe LIGHT OFF
 % with last 56 dimention blank
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 2;


% make initial stripe pattern one = light and background  zero = dark, 
stripe_pattern = [zeros( LEDdotsVertically, STRIPE_WIDTH ), ones( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;

for j = 2 : LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
    Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
end

% make last dimention blank light screen 56
Pats(:,:,LEDdotsAcross, PATTERN_INDEX) = ones( LEDdotsVertically , LEDdotsAcross );

% Make the whole matrix of y = 3 LEDs all ON
ONIndex = 3;
Pats(:, : , :, ONIndex) = 1;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_005_stripeVert2pixelDark_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern'); 
 
  %% Vertical Stripe LIGHT ON
 % with last 56 dimention blank
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 4; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 2;
gratingWidth = 4;
grating = zeros( 1 , LEDdotsAcross);

for i = 1: LEDdotsAcross  
    if( mod( i , gratingWidth * 2) < ( gratingWidth ) )
        grating(i) = 1; % add in light stripes at each of these locations
    end
end

% make initial stripe pattern one = light and background  zero = dark, 
stripe_pattern = [ones( LEDdotsVertically, STRIPE_WIDTH ), zeros( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;

for j = 2 : LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
    Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
end

% make last dimention blank black screen 56
Pats(:,:,LEDdotsAcross, PATTERN_INDEX) = zeros( LEDdotsVertically , LEDdotsAcross );

% Make the whole matrix of y = 3 LEDs all ON
ONIndex = 3;
Pats(:, : , :, ONIndex) = 1;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_006_stripeVert4pixelBright_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
  %% Vertical Stripe LIGHT ON
 % with last 56 dimention blank
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 4; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 2;


% make initial stripe pattern one = light and background  zero = dark, 
stripe_pattern = [zeros( LEDdotsVertically, STRIPE_WIDTH ), ones( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;

for j = 2 : LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
    Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
end

% make last dimention blank light screen 56
Pats(:,:,LEDdotsAcross, PATTERN_INDEX) = ones( LEDdotsVertically , LEDdotsAcross );

% Make the whole matrix of y = 3 LEDs all ON
ONIndex = 3;
Pats(:, : , :, ONIndex) = 1;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_007_stripeVert4pixelDark_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern'); 
 
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

% % cut off any frames past the end of POSITION_FUNCTION_LENGTH
% if (length (positionArray) > POSITION_FUNCTION_LENGTH)
%     disp('WARNING: position function does not fit symetrically within 1000 frame structure, consider revising')
%     positionArray = positionArray( 1: POSITION_FUNCTION_LENGTH);
% end

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

NUM_POSSIBLE_BAR_POSITIONS = 10: 2: 34; % 10 to 34 by steps of 2... since the bar is 2 pixels thick
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
 