

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

try
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

catch ME; rethrow(ME); end

%% CREATE BAR PATTERN

patternName = 'dot_size-2x2_yPos_11-12_Xdim-dotPosCCW_Ydim-brightness';
patternNum = 16;

barWidth = 2;               % bar width in LEDs
barYpos = 1:2; %1:VERT_LED_COUNT; % Y-indices (indexed from TOP to BOTTOM) of LEDs covered by the bar
gsVal = 4;       % Specifies grey scale range mapping of the values in Pats:
                    %   1: binary (0-1) 
                    %   2: 0-3
                    %   3: 0-7
                    %   4: 0-15
backgroundBrightness = 0;   % Maps onto to the selected gsVal range
barMotionDirection = 'CCW';  % Direction that bar moves as X dim increases - either "CW" or "CCW"

try
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

if strcmpi(barMotionDirection, 'ccw')
    missingX = 10:17;
else
    missingX = MISSING_PANEL_X_INDS;   
end

% Split the bar to create a smoother transition on the side of the missing panel that is closer to 
% the fly's visual field (i.e. more anterior). It might not make sense to do this for other missing
% panel locations.
yFillInds = MISSING_PANEL_Y_INDS(ismember(MISSING_PANEL_Y_INDS, barYpos));
if ~isempty(yFillInds)
    for iPos = 1:barWidth
        nextBarPos = nextXPos:(nextXPos + iPos - 1);
        
        
        Pats(yFillInds, nextBarPos, missingX(1) - barWidth + iPos, 1) ...
            = 1;
    end
    
    % Keep the "jumping" part of the bar waiting on the other side until the actual bar pos catches up
    nextBarPos = nextXPos:(nextXPos + barWidth - 1);
    Pats(yFillInds, nextBarPos, missingX(barWidth:end), 1) = 1;
end
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

catch ME; rethrow(ME); end


%% CREATE HIGH-LOW OPPOSING DOTS PATTERN

patternName = 'high-low-dots_size-2x2_yPos_1-2_9-10_Xdim-dotPos_top-CW_Ydim-brightness';
patternNum = 17;

dotSize = 2;               % dot width in LEDs

% Y-indices (indexed from TOP to BOTTOM) of LEDs covered by the bar
topDotYpos = 1:2;
bottomDotYpos = 11:12;
gsVal = 4;       % Specifies grey scale range mapping of the values in Pats:
                    %   1: binary (0-1) 
                    %   2: 0-3
                    %   3: 0-7
                    %   4: 0-15
backgroundBrightness = 0;   % Maps onto to the selected gsVal range
topDotMotionDirection = 'CCW';  % Direction that bar moves as X dim increases - either "CW" or "CCW"

try
    
% Add general info to pattern structure
pattern = [];
pattern.x_num = HORZ_LED_COUNT + 1; % Specifies size of X index of the left edge of the bar (except for the last position, which blanks the panels)
pattern.y_num = 16;              % Brightness of the dots from 0-15 (0 turns the bar off)
pattern.num_panels = VERT_PANEL_COUNT * HORZ_PANEL_COUNT; % Total number of panel addresses
pattern.gs_val = gsVal;
pattern.Panel_map = PANEL_ADDRESS_MAP;

% Construct the dot patterns within each dimension
Pats = zeros(VERT_LED_COUNT, HORZ_LED_COUNT, pattern.x_num, pattern.y_num); % --> [arenaY, arenaX, patternX, patternY]

if strcmpi(topDotMotionDirection, 'ccw')
    missingX = 10:17;
else
    missingX = MISSING_PANEL_X_INDS;
end

%------------ FILL IN TOP DOT PATTERN ---------------------

% Build intial dot pattern
topDotPattern = backgroundBrightness * ones(VERT_LED_COUNT, HORZ_LED_COUNT);
topDotPattern(topDotYpos, 1:dotSize) = 1;

% Fill X dimension of pattern array by shifting bar pattern clockwise by one LED as index increases
for xPos = 1:HORZ_LED_COUNT
    if strcmpi(topDotMotionDirection, 'cw')
        Pats(:, :, xPos, 1) = ShiftMatrix(topDotPattern, xPos - 1, 'r', 'y');
    elseif strcmpi(topDotMotionDirection, 'ccw')
        Pats(:, :, xPos, 1) = ShiftMatrix(topDotPattern, xPos - 1, 'l', 'y');
    else
        error('Invalid motion direction! Valid values are "CW" and "CCW".');
    end
end

% Make the LEDs from the upper row "jump" over the missing panel to keep total luminance within the 
% arena constant
if strcmpi(topDotMotionDirection, 'cw')
    nextXPos = MISSING_PANEL_X_INDS(end) + 1;
elseif strcmpi(topDotMotionDirection, 'ccw')
    nextXPos = MISSING_PANEL_X_INDS(end) + 1;
else
    error('Invalid motion direction! Valid values are "CW" and "CCW".');
end 

% Split the bar to create a smoother transition on the side of the missing panel that is closer to 
% the fly's visual field (i.e. more anterior). It might not make sense to do this for other missing
% panel locations.
yFillInds = MISSING_PANEL_Y_INDS(ismember(MISSING_PANEL_Y_INDS, topDotYpos));
if ~isempty(yFillInds)
    for iPos = 1:dotSize
        nextDotPos = nextXPos:(nextXPos + iPos - 1);

        Pats(yFillInds, nextDotPos, missingX(1) - dotSize + iPos, 1) ...
                = 1;
    end
    
    % Keep the "jumping" part of the bar waiting on the other side until the actual bar pos catches up
    nextDotPos = nextXPos:(nextXPos + dotSize - 1);
    Pats(yFillInds, nextDotPos, missingX(dotSize:end), 1) = 1;
end

%------------ FILL IN BOTTOM DOT PATTERN ---------------------

% Build intial dot pattern 
bottomDotPattern = backgroundBrightness * ones(VERT_LED_COUNT, HORZ_LED_COUNT);
bottomDotPattern(bottomDotYpos, 1:dotSize) = 1;

% Fill X dimension of pattern array by shifting bar pattern clockwise by one LED as index increases
if strcmpi(topDotMotionDirection, 'cw')
    bottomDotStartInd = HORZ_LED_COUNT - missingX(end - dotSize);
else
    bottomDotStartInd = HORZ_LED_COUNT - missingX(1) + 1;
end

for xPos = 1:HORZ_LED_COUNT
    if strcmpi(topDotMotionDirection, 'cw')
        shiftNum = bottomDotStartInd + xPos - 1;
        if shiftNum <= HORZ_LED_COUNT
            Pats(:, :, xPos, 1) = Pats(:, :, xPos, 1) + ...
                    ShiftMatrix(bottomDotPattern, shiftNum, 'l', 'y');
        else
            shiftNum = HORZ_LED_COUNT + (missingX(end-dotSize)) - xPos + 1;
            Pats(:, :, xPos, 1) = Pats(:, :, xPos, 1) + ...
                    ShiftMatrix(bottomDotPattern, shiftNum, 'r', 'y');
        end
    elseif strcmpi(topDotMotionDirection, 'ccw')
        shiftNum = bottomDotStartInd + xPos - dotSize;
        if shiftNum <= HORZ_LED_COUNT
            Pats(:, :, xPos, 1) = Pats(:, :, xPos, 1) + ...
                    ShiftMatrix(bottomDotPattern, shiftNum, 'r', 'y');
        else
            shiftNum = xPos - missingX(1) - 1;
            Pats(:, :, xPos, 1) = Pats(:, :, xPos, 1) + ...
                    ShiftMatrix(bottomDotPattern, shiftNum, 'r', 'y');
        end            
    else
        error('Invalid bar motion direction! Valid values are "CW" and "CCW".');
    end
end
yFillInds = MISSING_PANEL_Y_INDS(ismember(MISSING_PANEL_Y_INDS, bottomDotYpos));
if ~isempty(yFillInds)
    warning('WARNING: bottom dot is high enough to disappear when it passes the missing LED panel')
end

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
pattern.userData.dotSize = dotSize;
pattern.userData.topDotYpos = topDotYpos;
pattern.userData.bottomDotYpos = bottomDotYpos;
pattern.userData.topDotMotionDirection = topDotMotionDirection;
pattern.userData.backgroundBrightness = backgroundBrightness;
pattern.userData.missingPanelIndsX = MISSING_PANEL_X_INDS;
pattern.userData.missingPanelIndsY = MISSING_PANEL_Y_INDS;

catch ME; rethrow(ME); end

%% PREVIEW PATTERN

testPat = Pats;
yInd = 14;

for iX = 40%:size(testPat, 3)
    figure(1); clf;
    imagesc(squeeze(testPat(:, :, iX, yInd)));
    axis equal
    pause(0.1)
    drawnow()    
end


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
 
 
 