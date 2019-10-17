
saveDir = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Patterns_and_functions\functions';


%% LOAD CONSTANT PARAMETERS

paramFilePath = 'C:\Users\Wilson Lab\Documents\MATLAB\2P_acq_code\Panels_code\Patterns_and_functions\arena_config';
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

%% STEADY MOTION
% Moves along target pattern dimension at a steady rate (useful for swinging bar/object stimuli)

functionName = 'steadyMotion_dispRate-200_cycleTime-20_framesPerPos-42';
functionNum = 1;

displayRate = 200;
positionsPerCycle = HORZ_LED_COUNT;
cycleTime = 20; % this is the desired time to complete one cycle through the target dimension at 
% displayRate. NOTE: actual cycle time will be slightly different to ensure that the same integer 
% number of frames is spent at each position.

targetFramesPerCycle = displayRate * cycleTime;
framesPerPosition = round(targetFramesPerCycle / positionsPerCycle)
% ------------------------------------

actualCycleTime = (framesPerPosition * positionsPerCycle) / displayRate;
actualFramesPerCycle = displayRate * actualCycleTime;

% Create the position function array (note that it is zero indexed!)
positionArray = [];
for iFrame = 1:actualFramesPerCycle
    positionArray(iFrame) = fix((iFrame - 1) / framesPerPosition);
end

func = positionArray; % Needs to be named this for panels code to read it

%% SAVE POSITION FUNCTION

fileNamePrefix = ['position_function_', pad(num2str(functionNum), 3, 'left', '0')];
fileName = [fileNamePrefix, '_', functionName, '.mat'];

% Warn user if a position function with this number already exists in the save directory
myFiles = dir(fullfile(saveDir, [fileNamePrefix, '*']));
if ~isempty(myFiles)
    errordlg(['There is already a position function file with that number in this directory! ', ...
            'Please change the number or delete the original file before saving.'], ...
            'Error');
else
    % Save file
    save(fullfile(saveDir, fileName), 'func');
end 
 
