%make_Patterns_YEF


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
%pattern.gs_val = 1; 	% This pattern will be binary , so grey scale code is 1;
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

% trying to fix bug caused by controler update 7/27/17
pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9];

%pattern.Panel_map = [1, 3, 5, 7, 15, 11, 13 ; 2 , 4 ,6, 8, 16, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
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
 
   %% Vertical Stripe 4Pixels LIGHT ON
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
 
 
 %% Vertical Stripe 4 pixel LIGHT OFF
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
 
 
 
   %% Vertical Stripe UPPER LIGHT ON
 % with last 56 dimention blank
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 2; % number of LED dots wide
STRIPE_HEIGHT = 8; % LEDs high

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3; 		% Y will store, 1 = pattern (x), 2= ALL OFF, 3 = all ON, indicates all pixel values in pattern.Pats fall in the range of 0-7are

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
% Stripe only in the uppper half of the matrix
stripe_pattern = [  [ones( STRIPE_HEIGHT, STRIPE_WIDTH ); zeros(LEDdotsVertically - STRIPE_HEIGHT, STRIPE_WIDTH )], zeros( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

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
 str = [directory_name '\Pattern_008_stripeVert2pixelBright_UpperField_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
 %% Vertical Stripe UPPER LIGHT ON
 % with last 56 dimention blank
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 2; % number of LED dots wide
STRIPE_HEIGHT = 8; % LEDs high

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
% Stripe only in the uppper half of the matrix
stripe_pattern = [  [ zeros(LEDdotsVertically - STRIPE_HEIGHT, STRIPE_WIDTH ); ones( STRIPE_HEIGHT, STRIPE_WIDTH )], zeros( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ]; 

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
 str = [directory_name '\Pattern_009_stripeVert2pixelBright_LowerField_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
 
 %% Vertical Stripe DIFFERENT CONTRAST!! LIGHT ON  
 % with last 56 dimention blank
 % Note that the actual position depends on the initial position. See below.

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

STRIPE_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

CONTRAST_LEVELS = 7;
%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = 3 + CONTRAST_LEVELS - 1;% Y will store, 1 = OFF (x), 2= Pattern, 3 = all ON   4-9 (rest of the other 6contrasts)

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% indicates all pixel values in pattern.Pats fall in the range of 0 (dark) and 1-7

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Y = 1 % this will always be ALL LEDS OFF
OFF_INDEX = 1;
Pats(:, : , :, OFF_INDEX) = 0;

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEXES = [2 4 5 6 7 8 9]; %2, 4(2contrast) 5(3) 6(4) 7(5) 8(6) 9(7) 
PATTERN_CONTRAST_LEVELS = [ 1 2 3 4 5 6 7];

for i = 1: length( PATTERN_INDEXES )
    
    PATTERN_INDEX = PATTERN_INDEXES( i );
    CONTRAST_VAL = PATTERN_CONTRAST_LEVELS( i );
    % make initial stripe pattern one = light and background  zero = dark,
    stripe_pattern = [ CONTRAST_VAL*ones( LEDdotsVertically, STRIPE_WIDTH ), zeros( LEDdotsVertically , LEDdotsAcross - STRIPE_WIDTH ) ];
    
    Pats(:, :, 1, PATTERN_INDEX) = stripe_pattern;
    
    for j = 2 : LEDdotsAcross 			%use ShiftMatrixPats to rotate stripe image
        Pats(:,:,j, PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
    end
    
    % make last dimention blank black screen 56
    Pats(:,:,LEDdotsAcross, PATTERN_INDEX) = zeros( LEDdotsVertically , LEDdotsAcross );
    
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
 str = [directory_name '\Pattern_010_stripeVert2pixelBright_DiffContrast_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
%% ON bar of different widths at any location on the screen
clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

STRIPE_WIDTHS = [0, 1, 3, 7, 13, 25, 120 ]  ; % number of LED dots wide, all ON is used for full screen

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = numel( STRIPE_WIDTHS ); 

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% indicates all pixel values in pattern.Pats fall in the range of 0 (dark) and 1-7


MATRIX_SPACER = 100; 
xDim = MATRIX_SPACER*2 + LEDdotsAcross;

Pats = zeros( LEDdotsVertically, xDim, pattern.x_num, pattern.y_num ); 	%initializes the array with zeros

for i = 1: length( STRIPE_WIDTHS )
    
    currStripeWidth = STRIPE_WIDTHS (i); % current stripe width
    
    stripe_pattern = zeros(LEDdotsVertically, xDim);
    
    % make initial stripe pattern centered at x= 101  one = light and background  zero = dark,
    if( currStripeWidth > 0)
    stripeMiddle = MATRIX_SPACER + 1;
    % add middle row of stripe 
    stripe_pattern(:, stripeMiddle) = 1;
    end
    
    oneStripeSideWidth = ( currStripeWidth - 1 )/ 2;
    % add extra sides to the bar
    if( oneStripeSideWidth > 0 )
        % add left side stripe 
        stripe_pattern( :,  stripeMiddle - oneStripeSideWidth: stripeMiddle) = 1;
        
        % add right side stripe
        stripe_pattern( :, stripeMiddle:  stripeMiddle + oneStripeSideWidth) = 1;
    end
    
    for j = 1 : LEDdotsAcross 			%rotate stripe image to each location around the panel set up
        
         shift = j - 1;
         Pats(:, :, j, i) = shiftMatrix( stripe_pattern, shift) ;
    end
    
    
end

% cut out spacers on the side of the matrix
Pats = Pats (: , MATRIX_SPACER + 1 : MATRIX_SPACER + LEDdotsAcross, : , : );

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
  %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_011_stripeONdifferentWidths']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 %% OFF bar of different widths at any location on the screen
clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

STRIPE_WIDTHS = [0, 1, 3, 7, 13, 25, 120 ]  ; % number of LED dots wide, all ON is used for full screen

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store either ON of OFF for the full screen 
pattern.y_num = numel( STRIPE_WIDTHS ); 

pattern.num_panels = 14; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 3; 	% indicates all pixel values in pattern.Pats fall in the range of 0 (dark) and 1-7


MATRIX_SPACER = 100; 
xDim = MATRIX_SPACER*2 + LEDdotsAcross;

Pats = ones( LEDdotsVertically, xDim, pattern.x_num, pattern.y_num ); 	%initializes the array with ones

for i = 1: length( STRIPE_WIDTHS )
    
    currStripeWidth = STRIPE_WIDTHS (i); % current stripe width
    
    stripe_pattern = ones(LEDdotsVertically, xDim);
    
    % make initial stripe pattern centered at x= 101  one = light and background  zero = dark,
    if( currStripeWidth > 0)
    stripeMiddle = MATRIX_SPACER + 1;
    % add middle row of stripe 
    stripe_pattern(:, stripeMiddle) = 0;
    end
    
    oneStripeSideWidth = ( currStripeWidth - 1 )/ 2;
    % add extra sides to the bar
    if( oneStripeSideWidth > 0 )
        % add left side stripe 
        stripe_pattern( :,  stripeMiddle - oneStripeSideWidth: stripeMiddle) = 0;
        
        % add right side stripe
        stripe_pattern( :, stripeMiddle:  stripeMiddle + oneStripeSideWidth) = 0;
    end
    
    for j = 1 : LEDdotsAcross 			%rotate stripe image to each location around the panel set up
        
         shift = j - 1;
         Pats(:, :, j, i) = shiftMatrix( stripe_pattern, shift) ;
    end
    
    
end

% cut out spacers on the side of the matrix
Pats = Pats (: , MATRIX_SPACER + 1 : MATRIX_SPACER + LEDdotsAcross, : , : );

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [1, 3, 5, 7, 9, 11, 13 ; 2 , 4 ,6, 8, 10, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
  %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\NewPanelArena -Yvette\Matlab Codes\Patterns\';
 str = [directory_name '\Pattern_012_stripeOFFdifferentWidths']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
 
%% LIGHT ON dots at each location on the screen
%   The bar location is encoded as a single number in the x dim.
%   1 2 3  .... 55 (56 blank)
%   57 58....  111 (112 blank)
%   113    ....
% ...
%   840 ... (896 blank)  

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

DOT_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % this variable will where the dot is on the screen, 56 * 16
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

counter = 1;

for ypos = 1 : LEDdotsVertically - ( DOT_WIDTH - 1) ;
    
    % make initial dot pattern with upper right corner in the coordinates explained by X = xpos and y = 1 one = light and background  zero = dark,
    dot_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
    dot_pattern( ypos: ypos + DOT_WIDTH - 1 , 1 : DOT_WIDTH ) = 1;
    
    % currentDimention, since we are encoding both x and y position in a linear vector 
    currMatrixDim = 1 + LEDdotsAcross * (ypos  - 1) ;
    
    
    Pats(:, :, currMatrixDim , PATTERN_INDEX) = dot_pattern;
    
    for j = currMatrixDim + 1 : ( currMatrixDim + LEDdotsAcross ) 			%use ShiftMatrixPats to rotate stripe image
        
        
        Pats(: , : , j , PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
    end
    
    % make last dimention blank black screen 56, 112 ...
    Pats(:,:, (currMatrixDim + LEDdotsAcross - 1), PATTERN_INDEX) = zeros( LEDdotsVertically , LEDdotsAcross );
    
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
 str = [directory_name '\Pattern_013_2pixelBrightDot_56blank']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 
%% LIGHT ON dots at each location on the screen
%   The bar location is encoded as a single number in the x dim.
%   1 2 3  .... 55 (56 blank)
%   57 58....  111 (112 blank)
%   113    ....
% ...
%   840 ... (896 blank)  

clear all;
numOfPanelsAcross = 7;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

DOT_WIDTH = 4; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross * ( LEDdotsVertically - ( DOT_WIDTH - 1) ); % this variable will where the dot is on the screen, 56 * 16
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

counter = 1;

for ypos = 1 : LEDdotsVertically - ( DOT_WIDTH - 1) ;
    
    % make initial dot pattern with upper right corner in the coordinates explained by X = xpos and y = 1 one = light and background  zero = dark,
    dot_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
    dot_pattern( ypos: ypos + DOT_WIDTH - 1 , 1 : DOT_WIDTH ) = 1;
    
    % currentDimention, since we are encoding both x and y position in a linear vector 
    currMatrixDim = 1 + LEDdotsAcross * (ypos  - 1) ;
    
    
    Pats(:, :, currMatrixDim , PATTERN_INDEX) = dot_pattern;
    
    for j = currMatrixDim + 1 : ( currMatrixDim + LEDdotsAcross ) 			%use ShiftMatrixPats to rotate stripe image
        
        
        Pats(: , : , j , PATTERN_INDEX) = ShiftMatrix(Pats(:,:, j-1, PATTERN_INDEX),1,'r','y');
    end
    
    % make last dimention blank black screen 56, 112 ...
    Pats(:,:, (currMatrixDim + LEDdotsAcross), PATTERN_INDEX) = zeros( LEDdotsVertically , LEDdotsAcross );
    
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
 str = [directory_name '\Pattern_014_4pixelBrightDot_56blank']; 	% name must begin with ‘Pattern_’
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
pattern.gs_val = 1; 	% This pattern will be binary , so grey scale code is 1;
%pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

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

% trying to fix bug caused by controler update 7/27/17
pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9];

%pattern.Panel_map = [1, 3, 5, 7, 15, 11, 13 ; 2 , 4 ,6, 8, 16, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_015_stripeVert2pixelBright_gs1']; 	% name must begin with ‘Pattern_’
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
pattern.gs_val = 2; 	% This pattern will be binary , so grey scale code is 1;
%pattern.gs_val = 3; 	% This pattern will be binary , so grey scale code is 1;

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

% trying to fix bug caused by controler update 7/27/17
pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9];

%pattern.Panel_map = [1, 3, 5, 7, 15, 11, 13 ; 2 , 4 ,6, 8, 16, 12, 14]; 	% define panel structure vector - YEF arena 2017

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_016_stripeVert2pixelBright_gs2']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 
 