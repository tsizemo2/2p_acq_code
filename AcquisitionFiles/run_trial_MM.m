function [ trial_data, trial_time, outputData ] = run_trial_MM( task, run_obj, scanimage_client, trialCoreName )

global s

disp(['About to start trial task: ' task]);

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

% Parse task name
taskDivs = strfind(task, '-');
taskType = task(1:taskDivs(1)-1);
stimOnset = str2double(task(taskDivs(2)+1:taskDivs(3)-1));
stimDur = str2double(task(taskDivs(4)+1:end));

% Initialize the output vectors to zero
zeroStim = zeros(SAMPLING_RATE * run_obj.trialDuration, 1);
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
analogStimCommand = stimCommand * 10;
pulseStimCommand(pairStimStartSample:pairStimEndSample) = 1;

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

% Set up scanimage trigger
imagingTrigger = zeroStim;
imagingTrigger(2:end-1) = 1.0;
%%

outputData = [];
% output_data = [imaging trigger, speaker, valve A/shutoff B, valve B/shutoff A, NO valve, cameraTrigger]
if( strcmp(taskType, 'OdorA') == 1 )
    outputData = [imagingTrigger, zeroStim, stimCommand, zeroStim, stimCommand, cameraTrigger];
elseif( strcmp(taskType, 'OdorB') == 1 )
    outputData = [imagingTrigger, zeroStim, zeroStim, stimCommand, stimCommand, cameraTrigger];
elseif( strcmp(taskType, 'OdorAPair') == 1 )
    outputData = [imagingTrigger, zeroStim, pulseStimCommand, zeroStim, pulseStimCommand, cameraTrigger];
elseif( strcmp(taskType, 'OdorBPair') == 1 )
    outputData = [imagingTrigger, zeroStim, zeroStim, pulseStimCommand, pulseStimCommand, cameraTrigger];
elseif( strcmp(taskType, 'NoOdor') == 1 || strcmp(taskType, 'NoStim') == 1 )
    outputData = [imagingTrigger, zeroStim, zeroStim, zeroStim, zeroStim, cameraTrigger];
elseif( strcmp(taskType, 'AirStop') == 1)
    outputData = [imagingTrigger, zeroStim, zeroStim, zeroStim, stimCommand, cameraTrigger];
elseif( strcmp(taskType, 'Sound') == 1)
    outputData = [imagingTrigger, speakerStimCommand, zeroStim, zeroStim, zeroStim, cameraTrigger];
else
    disp('Warning: unrecognized stim type...running trial with no stim.')
    outputData = [imagingTrigger, zeroStim, zeroStim, zeroStim, zeroStim, cameraTrigger];
end

outputData(end, :) = 0; % To make sure the stim doesn't stay on between trials
queueOutputData(s, outputData);

% Trigger scanimage run if using 2p.
if(run_obj.using2P == 1)
    scanimage_file_str = ['cdata_' trialCoreName '_tt_', num2str(run_obj.trialDuration), '_'];
    fprintf(scanimage_client, [scanimage_file_str]);
    disp(['Wrote: ' scanimage_file_str ' to scanimage server' ]);
    acq = fscanf(scanimage_client, '%s');
    disp(['Read acq: ' acq ' from scanimage server' ]);
end

% Delay starting the aquisition for a second to ensure that scanimage is ready
pause(1.0);

[trial_data, trial_time] = s.startForeground();

release(s);
end