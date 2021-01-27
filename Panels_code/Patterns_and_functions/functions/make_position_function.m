
saveDir = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\Patterns_and_functions\functions';


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

%% STEADY MOTION
% Moves along target pattern dimension at a steady rate (useful for swinging bar/object stimuli)

functionName = 'steadyMotion_dispRate-50_cycleTime-20_framesPerPos-10';
functionNum = 1;

displayRate = 50;
positionsPerCycle = HORZ_LED_COUNT;
cycleTime = 20; % this is the desired time to complete one cycle through the target dimension at 
% displayRate. NOTE: actual cycle time will be slightly different to ensure that the same integer 
% number of frames is spent at each position.

targetFramesPerCycle = displayRate * cycleTime;
framesPerPosition = round(targetFramesPerCycle / positionsPerCycle);
% ------------------------------------

actualCycleTime = (framesPerPosition * positionsPerCycle) / displayRate;
actualFramesPerCycle = displayRate * actualCycleTime;

% Create the position function array (note that it is zero indexed!)
positionArray = [];
for iFrame = 1:actualFramesPerCycle
    positionArray(iFrame) = fix((iFrame - 1) / framesPerPosition);
end

func = positionArray; % Needs to be named this for panels code to read it

%% STATIC
% Stays at the initial position without moving

offsetNum = 14;
functionName = ['static_offset-', num2str(offsetNum), '_framesPerCycle-1000'];
functionNum = 6;

framesPerCycle = 1000;

% positionArray = zeros(1, framesPerCycle);
positionArray = ones(1, framesPerCycle) * offsetNum;

func = positionArray;


%% TIMED INDEX JUMP
% Switches from a "home" position to specific indices at arbitrary times (useful for
% making a stimulus appear and disappear)

% functionName = 'bar_flash_LRMid_500_msec_dur_background_behind_dispRate-50_cycleTime-20';
functionName = 'full_field_flash_Dur-250-msec_Onset_5-sec_Brightness_100_dispRate-50_cycleTime_10';
functionNum = 13;

homePosition = 1;
targetPositions = [15];
onsetTimes = [5];
offsetTimes = [5.25];

% homePosition = 93;
% targetPositions = [20 68 44];
% onsetTimes = [3 10 17];
% offsetTimes = [3.5, 10.5, 17.5];


displayRate = 50;
cycleTime = 10;
% cycleTime = 20;

% Convert times to frames
onsetFrames = ceil(onsetTimes * displayRate);
offsetFrames = ceil(offsetTimes * displayRate);

% Create the position function array (note that it is zero indexed!)
framesPerCycle = ceil(displayRate * cycleTime);
positionArray = ones(1, framesPerCycle) * homePosition - 1;
for iOnset = 1:numel(onsetFrames)
    positionArray(onsetFrames(iOnset):offsetFrames(iOnset)) = targetPositions(iOnset) - 1;
end

func = positionArray; % Needs to be named this for panels code to read it

%%

functionName = 'bath_ATP_exp_dispRate-50_cycleTime-20_framesPerPos-10_baselineDur_180';
functionNum = 14;

baselineDur = 300;
displayRate = 50;
positionsPerCycle = HORZ_LED_COUNT;
cycleTime = 20; % this is the desired time to complete one cycle through the target dimension at 
% displayRate. NOTE: actual cycle time will be slightly different to ensure that the same integer 
% number of frames is spent at each position.

targetFramesPerCycle = displayRate * cycleTime;
framesPerPosition = round(targetFramesPerCycle / positionsPerCycle);

actualCycleTime = (framesPerPosition * positionsPerCycle) / displayRate;
actualFramesPerCycle = displayRate * actualCycleTime;

% Create the position function array (note that it is zero indexed!)
positionArray = [];
for iFrame = 1:actualFramesPerCycle
    positionArray(iFrame) = fix((iFrame - 1) / framesPerPosition);
end

% Blank alternating cycles after the end of the baseline period
targetBaselineDurFrames = displayRate * baselineDur;
actualBaselineDurFrames = actualFramesPerCycle * ...
        mod(actualFramesPerCycle, targetBaselineDurFrames);


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
 
