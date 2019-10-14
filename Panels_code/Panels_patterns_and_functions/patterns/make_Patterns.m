%make patterns

%% LIGHT ON dots 2 LED wide vertical bar
%   The bar's horizontal location is encoded in x dim 
% whether the bar is on or not is encoded in y dim

clear all;
numOfPanelsAcross = 12;% panels across
numOfPanelsVertically = 2;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

BAR_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 56 for yvette's set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 16 for yvette's current set up

missingPanelXPos = (10*LEDdotsPerPanel + 1):(10*LEDdotsPerPanel + LEDdotsPerPanel); % LED positions of the panel that is removed for the FicTrac camera to look through
missingPanelYPos =  1:(LEDdotsVertically/2); % (LEDdotsVertically/2 + 1):LEDdotsVertically;

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will where the dot is on the screen in x, last dim = 56 is blank
pattern.y_num = 2; 		% Y will encode if the bar is displayed=1, not displayed= 2;

pattern.num_panels = 24; %18; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light

% build intial bar pattern 
bar_pattern = zeros(LEDdotsVertically, LEDdotsAcross) ;
bar_pattern(:, 1:BAR_WIDTH) = 1; % draw light dot into matrix


for xpos = 1:LEDdotsAcross
    
    % shift dot_pattern to each different location depending on current
    % x pos
    Pats(:, :, xpos, 1) = ShiftMatrix(bar_pattern, xpos - 1, 'r', 'y'); % place
    
end

%---------- Make the LEDs from the upper row "jump" over the missing panel 
%   to keep total luminance within the arena constant --------------------- 
nextXPos = missingPanelXPos(end) + 1;

% Split the bar until it has fully disappeared into the missing panel
for iPos = 1:(BAR_WIDTH)
    nextBarPos = nextXPos:(nextXPos + iPos - 1);
    Pats(missingPanelYPos, nextBarPos, missingPanelXPos(1) - BAR_WIDTH + iPos, :) = 1;
end

% Just keep it waiting on the other side until the actual bar pos catches up
nextBarPos = nextXPos:(nextXPos + BAR_WIDTH - 1);
Pats(missingPanelYPos, nextBarPos, missingPanelXPos(2:end), :) = 1;
% -------------------------------------------------------------------------


% Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, :, pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

pattern.Panel_map = [23, 19, 15, 22, 18, 14 , 21, 17, 13, 24, 20, 16 ; 11 , 7 ,3, 10, 6, 2, 9, 5, 1, 12, 8, 4 ]; 	% 360 degree arena

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Panels_patterns_and_functions\patterns';
 str = [directory_name '\Pattern_001_2pixelBrightVertBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');