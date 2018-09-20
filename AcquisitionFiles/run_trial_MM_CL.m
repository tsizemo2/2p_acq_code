function [ trial_data, trial_time, outputData ] = run_trial_MM_CL( task, run_obj, scanimage_client, trialCoreName )

global s

disp(['About to start trial task: ' task]);

% Setup data structures for read / write on the daq board
s = daq.createSession('ni');

% This channel is for external triggering of scanimage 5.1
s.addDigitalChannel('Dev1', 'port0/line0', 'OutputOnly');

% Add dummy analog input channel just to use its clock (might be FicTrac X
% movement)
s.addAnalogInputChannel('Dev1', 0, 'Voltage');

% Add analog input channels for FicTrac data
ai_channels_used = [5:7, 14:15];
aI = s.addAnalogInputChannel('Dev1', ai_channels_used, 'Voltage');
for i=1:length(ai_channels_used)
    aI(i).InputType = 'SingleEnded';
end

% Add closed loop activation output channel
s.addAnalogOutputChannel('Dev1', 0, 'Voltage');

% Add output channel for camera trigger (7)
s.addDigitalChannel('Dev1', ['port0/line7'], 'OutputOnly');

% Input channels:
%
%   Dev1:
%       AI.5 = olfactometer valve A/shutoff B command
%       AI.6 = olfactometer valve B/shutoff A command
%       AI.7 = olfactometer NO valve command
%       AI.14 = FicTrac Yaw
%       AI.15 = FicTrac XY
%
% Output channels:
%
%   Dev1:
%       P0.0        = external trigger for scanimage
%       AO.0        = closed loop activation output
%       P0.7        = camera trigger

settings = sensor_settings;
SAMPLING_RATE = settings.sampRate;
s.Rate = SAMPLING_RATE;
FRAME_RATE = 25; % This is the behavior camera frame rate

% Initialize the output vectors to zero
zeroStim = zeros(SAMPLING_RATE * run_obj.trialDuration, 1);
cameraTrigger = zeroStim;

% Generate closed loop activation command
CL_command =  ones(SAMPLING_RATE * run_obj.trialDuration, 1) * 10;

% Set up camera trigger output
triggerInterval = round(SAMPLING_RATE / FRAME_RATE);
cameraTrigger(1:triggerInterval:end) = 1;

% Set up scanimage trigger
imagingTrigger = zeroStim;
imagingTrigger(2:end-1) = 1.0;

%%

outputData = [imagingTrigger, CL_command, cameraTrigger];
outputData(end, :) = 0; % To make sure the stim doesn't stay on at end of trial
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