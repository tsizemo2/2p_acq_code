function [ trial_data, trial_time, outputData ] = run_trial_MM( tasks, run_obj, scanimage_client, trialCoreName )

global s

% Setup data structures for read / write on the daq board
s = daq.createSession('ni');

% This channel is for external triggering of scanimage 5.1
s.addDigitalChannel('Dev1', 'port0/line0', 'OutputOnly');

% Add output channel for speaker
s.addAnalogOutputChannel('Dev1', 2, 'Voltage');

% Add output channels for olfactometer (2-6) and camera trigger (7)
chanIDs = {'port0/line1', 'port0/line2', 'port0/line3', 'port0/line7'};
s.addDigitalChannel('Dev1', chanIDs, 'OutputOnly');

% Input channels:
%
%   Dev1:
%       AI.8 = FicTrac X
%       AI.9 = FicTrac Yaw
%       AI.10 = FicTrac Y
%
% Output channels:
%
%   Dev1:
%       P0.0        = external trigger for scanimage
%       AO.2        = speaker output
%       P0.1        = olfactometer valve A/shutoff B
%       P0.2        = olfactometer valve B/shutoff A
%       P0.3        = olfactometer NO valve ("dummy") 
%       P0.7        = camera trigger

settings = sensor_settings;
SAMPLING_RATE = settings.sampRate;
s.Rate = SAMPLING_RATE;
FRAME_RATE = 25; % This is the behavior camera frame rate
nTrials = run_obj.nTrials;
trialDuration = run_obj.trialDuration;
blockDuration = trialDuration * nTrials;

allOutputData = [];
for iTrial = 1:nTrials
    
    % Parse task name
    currTask = tasks{iTrial};
    taskDivs = strfind(currTask, '-');
    taskType = currTask(1:taskDivs(1)-1);
    stimOnset = str2double(currTask(taskDivs(2)+1:taskDivs(3)-1));
    stimDur = str2double(currTask(taskDivs(4)+1:end));
    
    % Initialize the output vectors to zero
    zeroStim = zeros(SAMPLING_RATE * trialDuration, 1);
    stimCommand = zeroStim;
    cameraTrigger = zeroStim;

    % Set up stim output
    stimStartTime = stimOnset;
    stimEndTime = stimStartTime + stimDur;
    pairStimStartTime = stimEndTime + stimDur;
    pairStimEndTime = pairStimStartTime + stimDur;
    stimStartSample = round(stimStartTime * SAMPLING_RATE);
    stimEndSample = round(stimEndTime * SAMPLING_RATE);
    pairStimStartSample = round(pairStimStartTime * SAMPLING_RATE);
    pairStimEndSample = round(pairStimEndTime * SAMPLING_RATE);

    % Create stim output vectors
    stimCommand(stimStartSample:stimEndSample) = 1;
    pulseStimCommand = stimCommand;
    latePulseCommand = zeroStim;
    analogStimCommand = stimCommand * 10;
    pulseStimCommand(pairStimStartSample:pairStimEndSample) = 1;
    latePulseCommand((pairStimStartSample:pairStimEndSample) = 1;

    % Create speaker output vector
    speakerStimCommand = zeroStim;
    f = 200;
    ts = 1/SAMPLING_RATE;
    t = 0:ts:stimDur;
    sineTone = sin(2*pi*f*t) * 10;
    speakerStimCommand(stimStartSample:stimEndSample) = sineTone;
    
    % Set up camera trigger output
    triggerInterval = round(SAMPLING_RATE / FRAME_RATE);
    cameraTrigger(1:triggerInterval:end) = 1;

    % output_data =         [speaker,            valve A/shutoff B,  valve B/shutoff A,  NO valve,           cameraTrigger]
    switch taskType
        case 'OdorA'
            outputData =    [zeroStim,           stimCommand,        zeroStim,           stimCommand,        cameraTrigger];
        case 'OdorB'
            outputData =    [zeroStim,           zeroStim,           stimCommand,        stimCommand,        cameraTrigger];
        case 'OdorAPair'
            outputData =    [zeroStim,           pulseStimCommand,   zeroStim,           pulseStimCommand,   cameraTrigger];
        case 'OdorBPair'
            outputData =    [zeroStim,           zeroStim,           pulseStimCommand,   pulseStimCommand,   cameraTrigger];
        case 'OdorABPair'
            outputData =    [zeroStim,           stimCommand,        latePulseCommand,   pulseStimCommand,   cameraTrigger];
        case 'OdorBAPair'
            outputData =    [zeroStim,           latePulseCommand,   stimCommand,        pulseStimCommand,   cameraTrigger];
        case {'NoOdor', 'NoStim'}
            outputData =    [zeroStim,           zeroStim,           zeroStim,           zeroStim,           cameraTrigger];
        case 'AirStop'
            outputData =    [zeroStim,           zeroStim,           zeroStim,           stimCommand,        cameraTrigger];
        case 'Sound'
            outputData =    [speakerStimCommand, zeroStim,           zeroStim,           zeroStim,           cameraTrigger];
        otherwise
            disp('Warning: unrecognized stim type...running trial with no stim.')
            outputData =    [imagingTrigger,    zeroStim,           zeroStim,           zeroStim,           zeroStim,           cameraTrigger];
    end
    allOutputData = cat(1, allOutputData, outputData);
end%iTrial

% Set up scanimage trigger
imagingTrigger = zeros(size(allOutputData, 1), 1);
imagingTrigger(2:end-1) = 1;
allOutputData = [imagingTrigger, allOutputData];


outputData(end, :) = 0; % To make sure the stim doesn't stay on at end of block
queueOutputData(s, outputData);

% Trigger scanimage run if using 2p.
if(run_obj.using2P == 1)
    scanimage_file_str = ['cdata_' trialCoreName '_tt_', num2str(run_obj.trialDuration), '_'];
    fprintf(scanimage_client, ['nTrials: ', num2str(nTrials)]);
    fprintf(scanimage_client, ['trialDuration: ', num2str(trialDuration)]);
    fprintf(scanimage_client, [scanimage_file_str]);
    disp(['Wrote: ' scanimage_file_str ' to scanimage server' ]);
    acq = fscanf(scanimage_client, '%s');
    disp(['Read acq: ' acq ' from scanimage server' ]);
end

% Delay starting the aquisition for 2 seconds to ensure that scanimage is ready
pause(1.0);

[trial_data, trial_time] = s.startForeground();

release(s);
end