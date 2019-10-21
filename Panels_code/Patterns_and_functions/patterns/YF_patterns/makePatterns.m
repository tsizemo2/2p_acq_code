

saveDir = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Patterns_and_functions\patterns';


%% SET CONSTANT PARAMETERS

% Basic arena structure
VERT_PANEL_COUNT = 2;
HORZ_PANEL_COUNT = 12;
N_LEDS_PER_PANEL = 8;
HORZ_LED_COUNT = HORZ_PANEL_COUNT * N_LEDS_PER_PANEL;
VERT_LED_COUNT = VERT_PANEL_COUNT * N_LEDS_PER_PANEL;

% Positions of LEDs on the panel that is removed for the FicTrac camera to look through
MISSING_PANEL_X_INDS = 81:88;   % Missing panel is the 11th horizontally (indexed clockwise starting at fly's 7 o'clock position)
MISSING_PANEL_Y_INDS = 1:8;     % Missing panel is in the top row (indexed from top to bottom)


PANEL_ADDRESS_MAP = [23, 19, 15, 22, 18, 14, 21, 17, 13, 24, 20, 16; ...
                     11, 7, 3, 10, 6, 2, 9, 5, 1, 12, 8, 4];

%% LIGHT ON dots 2 LED wide vertical bar
% The bar's horizontal location is encoded in x dim 
% whether the bar is on or not is encoded in y dim

patternName = 'bright_bar_height-16_width-2_brightness-33_Xdim-barPos_Ydim-barOnOff';
patternNum = 1;

barWidth = 2;               % bar width in LEDs
barYpos = 1:VERT_LED_COUNT; % Y-indices (indexed from TOP to BOTTOM) of LEDs covered by the bar
gsVal = 2;       % Specifies grey scale range mapping of the values in Pats:
                    %   1: binary (0-1) 
                    %   2: 0-3
                    %   3: 0-7
                    %   4: 0-15
barBrightness = 1; % Maps onto to the selected gsVal

% Add general info to pattern structure
pattern = [];
pattern.x_num = HORZ_LED_COUNT; % Specifies X index of the left edge of the bar
pattern.y_num = 2;              % Binary variable specifying whether to show (1) or hide (2) the bar
pattern.num_panels = VERT_PANEL_COUNT * HORZ_PANEL_COUNT; % Total number of panel addresses
pattern.gs_val = gsVal;


% Construct the dot patterns within each dimention
Pats = zeros(VERT_LED_COUNT, HORZ_LED_COUNT, pattern.x_num, pattern.y_num); % --> [arenaY, arenaX, patternX, patternY]

% Build intial bar pattern 
barPattern = zeros(VERT_LED_COUNT, HORZ_LED_COUNT) ;
barPattern(barYpos, 1:barWidth) = barBrightness;

% Fill pattern array by shifting bar pattern clockwise by one LED as X index increases
for xPos = 1:HORZ_LED_COUNT
    Pats(:, :, xPos, 1) = ShiftMatrix(barPattern, xPos - 1, 'r', 'y');
end

%---------------------------------------------------------------------------------------------------
% Make the LEDs from the upper row "jump" over the missing panel to keep total luminance within the 
% arena constant
nextXPos = MISSING_PANEL_X_INDS(end) + 1;

% Split the bar to create a smoother transition on the side of the missing panel that is closer to 
% the fly's visual field (i.e. more anterior). It might not make sense to do this for other missing
% panel locations.
for iPos = 1:barWidth
    nextBarPos = nextXPos:(nextXPos + iPos - 1);
    Pats(MISSING_PANEL_Y_INDS, nextBarPos, MISSING_PANEL_X_INDS(1) - barWidth + iPos, 1) = 1;
end

% Keep the "jumping" pard of the bar waiting on the other side until the actual bar pos catches up
nextBarPos = nextXPos:(nextXPos + barWidth - 1);
Pats(MISSING_PANEL_Y_INDS, nextBarPos, MISSING_PANEL_X_INDS(barWidth:end), :) = 1;
% --------------------------------------------------------------------------------------------------

% Add remaining data to pattern structure
pattern.Pats = Pats;
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Panels_patterns_and_functions\patterns';
 str = [directory_name '\Pattern_001_2pixelBrightVertBar']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');