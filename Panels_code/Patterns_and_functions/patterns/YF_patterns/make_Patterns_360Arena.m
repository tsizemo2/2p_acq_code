%Make_Pattern_360Arena
%% 4 pixel wide grating, 8 pixel period:
clear all;
numOfPanelsAcross = 12;% 9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 4; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;

pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the grating pattern in Y = 2, and all x values
% zeros 0 = dark, ones 1 = light
PATTERN_INDEX = 1;
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

% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
%% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_012_4pixelGrating']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
 %%
 %% LIGHT ON dots 2 LED wide vertical bar
%   The bar's horizontal location is encoded in x dim 
% whether the bar is on or not is encoded in y dim

clear all;
numOfPanelsAcross = 12;% 9;% 7 panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;

pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light

% build intial bar pattern 
bar_pattern = zeros( LEDdotsVertically , LEDdotsAcross) ;
bar_pattern( : , 1 : BAR_WIDTH ) = 1; % draw light dot into matrix


for xpos = 1: LEDdotsAcross - ( BAR_WIDTH - 1)
    
    % shift dot_pattern to each different location depending on current
    % x pos
    Pats(:, :, xpos , 1) = ShiftMatrix (bar_pattern, (xpos - 1),'r','y'); % place
    
end


% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

%pattern.Panel_map = [4, 5, 12, 14, 6, 11, 13 ; 1 , 2 ,7, 10, 3, 8, 9]; 	% define panel structure vector - YEF arena updated 8/2017
%pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4]; 	% 230 degree arena updated 10/25/17 define panel structure vector
pattern.Panel_map = [9, 12, 13, 15, 17, 14, 16, 18, 8 , 19, 20, 21 ; 1 , 5 ,2, 6, 10, 3, 7, 11, 4, 22, 23, 24 ]; 	% 360 degree arena updated 10/25/17 define panel structure vector
% panels 19-24 are fictive and do not actually exist on hardware!

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson\Documents\GitHub\panels-patternsAndFunctions_YEF\patterns';
 str = [directory_name '\Pattern_003_2pixelBrightVertBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');

 %%
 
 
 