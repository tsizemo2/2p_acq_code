

saveDir = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Patterns_and_functions\patterns';


%% LOAD CONSTANT PARAMETERS

paramFilePath = 'C:\Users\Wilson Lab\Desktop\Michael\2P_acq_code\Panels_code\Patterns_and_functions\arena_config';
load(fullfile(paramFilePath, 'arena_setup_parameters.mat'));

% Contains hardcoded variables (example values from MM's setup):
    % VERT_PANEL_COUNT = 2
    % HORZ_PANEL_COUNT = 12
    % N_LEDS_PER_PANEL = 8
    % HORZ_LED_COUNT = HORZ_PANEL_COUNT * N_LEDS_PER_PANEL
    % VERT_LED_COUNT = VERT_PANEL_COUNT * N_LEDS_PER_PANEL
    % MISSING_PANEL_X_INDS = 81:88   % Missing panel is the 11th horizontally (indexed clockwise starting at fly's 7 o'clock position)
    % MISSING_PANEL_Y_INDS = 1:8     % Missing panel is in the top row (indexed from top to bottom)
    % PANEL_ADDRESS_MAP = [23, 19, 15, 22, 18, 14, 21, 17, 13, 24, 20, 16; ...
%                          11, 7, 3, 10, 6, 2, 9, 5, 1, 12, 8, 4];


%% CREATE FULL FIELD ILLUMINATION PATTERN

patternName = 'All-Panels-On_Xdim-Brightness_Ydim-OnOff';
patternNum = 7;

gsVal = 4; % Always use this value for consistent indexing

% Add general info to pattern structure
pattern = [];
pattern.x_num = 16;             % One for each possible brightness level
pattern.y_num = 2;              % Binary variable specifying whether to hide (1) or show (2) the pattern
pattern.num_panels = VERT_PANEL_COUNT * HORZ_PANEL_COUNT; % Total number of panel addresses
pattern.gs_val = gsVal;
pattern.Panel_map = PANEL_ADDRESS_MAP;

% Fill in full arena for various brightness values
Pats = zeros(VERT_LED_COUNT, HORZ_LED_COUNT, pattern.x_num, pattern.y_num); % --> [arenaY, arenaX, patternX, patternY]
for iPos = 1:pattern.x_num
    Pats(:, :, iPos, 2) = iPos-1;
end

% Add remaining data to pattern structure
pattern.Pats = Pats;
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

% Add metadata to pattern structure (for reference only; not used by panels functions)
pattern.userData.patternNum = patternNum;
pattern.userData.patternName = patternName;
pattern.userData.missingPanelIndsX = MISSING_PANEL_X_INDS;
pattern.userData.missingPanelIndsY = MISSING_PANEL_Y_INDS;

%% CREATE BAR PATTERN

patternName = 'Bar_height-16_width-2_Xdim-barPosCW_Ydim-brightness';
patternNum = 8;

barWidth = 2;               % bar width in LEDs
barYpos = 1:VERT_LED_COUNT; % Y-indices (indexed from TOP to BOTTOM) of LEDs covered by the bar
gsVal = 4;       % Specifies grey scale range mapping of the values in Pats:
                    %   1: binary (0-1) 
                    %   2: 0-3
                    %   3: 0-7
                    %   4: 0-15
backgroundBrightness = 0;   % Maps onto to the selected gsVal range
barMotionDirection = 'CW';  % Direction that bar moves as X dim increases - either "CW" or "CCW"

% Add general info to pattern structure
pattern = [];
pattern.x_num = HORZ_LED_COUNT + 1; % Specifies X index of the left edge of the bar (except for the last position, which blanks the panels)
pattern.y_num = 16;              % Brightness of the bar from 0-15 (0 turns the bar off)
pattern.num_panels = VERT_PANEL_COUNT * HORZ_PANEL_COUNT; % Total number of panel addresses
pattern.gs_val = gsVal;
pattern.Panel_map = PANEL_ADDRESS_MAP;

% Construct the dot patterns within each dimension
Pats = zeros(VERT_LED_COUNT, HORZ_LED_COUNT, pattern.x_num, pattern.y_num); % --> [arenaY, arenaX, patternX, patternY]

% Build intial bar pattern 
barPattern = backgroundBrightness * ones(VERT_LED_COUNT, HORZ_LED_COUNT);
barPattern(barYpos, 1:barWidth) = 1;

% Fill X dimension of pattern array by shifting bar pattern clockwise by one LED as index increases
for xPos = 1:HORZ_LED_COUNT
    if strcmpi(barMotionDirection, 'cw')
        Pats(:, :, xPos, 1) = ShiftMatrix(barPattern, xPos - 1, 'r', 'y');
    elseif strcmpi(barMotionDirection, 'ccw')
        Pats(:, :, xPos, 1) = ShiftMatrix(barPattern, xPos - 1, 'l', 'y');
    else
        error('Invalid bar motion direction! Valid values are "CW" and "CCW".');
    end
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
    Pats(MISSING_PANEL_Y_INDS, nextBarPos, MISSING_PANEL_X_INDS(1) - barWidth + iPos, 1) ...
            = 1;
end

% Keep the "jumping" part of the bar waiting on the other side until the actual bar pos catches up
nextBarPos = nextXPos:(nextXPos + barWidth - 1);
Pats(MISSING_PANEL_Y_INDS, nextBarPos, MISSING_PANEL_X_INDS(barWidth:end), 1) = 1;
% --------------------------------------------------------------------------------------------------

% Adjust brightness values along the Y dimension
for iY = 2:16
    Pats(:, :, :, iY) = Pats(:, :, :, 1) .* (iY - 1);
end
Pats(:, :, :, 1) = 0; % Blank pattern when y=0

% Add remaining data to pattern structure
pattern.Pats = Pats;
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
% Add metadata to pattern structure (for reference only; not used by panels functions)
pattern.userData.patternNum = patternNum;
pattern.userData.patternName = patternName;
pattern.userData.barWidth = barWidth;
pattern.userData.barYpos = barYpos;
pattern.userData.barMotionDirection = barMotionDirection;
pattern.userData.backgroundBrightness = backgroundBrightness;
pattern.userData.missingPanelIndsX = MISSING_PANEL_X_INDS;
pattern.userData.missingPanelIndsY = MISSING_PANEL_Y_INDS;

%% SAVE PATTERN

fileNamePrefix = ['Pattern_', pad(num2str(patternNum), 3, 'left', '0')];
fileName = [fileNamePrefix, '_', patternName, '.mat'];

% Warn user if a pattern with this number already exists in the save directory
myFiles = dir(fullfile(saveDir, [fileNamePrefix, '*']));
if ~isempty(myFiles)
    errordlg(['There is already a pattern file with that number in this directory! ', ...
            'Please change the pattern number or delete the original file before saving.'], ...
            'Pattern Number Error');
else
    % Save the pattern file
    save(fullfile(saveDir, fileName), 'pattern');
end 
 
 
 