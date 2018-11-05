function [ trial_data, outputData ] = run_trial_MM_CL( task, run_obj, scanimage_client, trialCoreName )

global s

disp(['About to start trial task: ' task]);

% Input channels:
%
%   Dev1:
%       AI.4 = FicTrac X
%       AI.5 = FicTrac Y
%       AI.6 = FicTrac Yaw
%       AI.7 = camera strobe
%       AI.13 = olfactometer valve A/shutoff B command
%       AI.14 = olfactometer valve B/shutoff A command
%       AI.15 = olfactometer NO valve command
%
% Output channels:
%
%   Dev1:
%       P0.0        = external trigger for scanimage
%       AO.3        = closed loop activation output
%       P0.7        = camera trigger

% Setup data structures for read / write on the daq board
s = daq.createSession('ni');

% This channel is for external triggering of scanimage 5.1
s.addDigitalChannel('Dev1', 'port0/line0', 'OutputOnly');

% Add analog input channels for FicTrac data
ai_channels_used = [4:7, 13:15];
aI = s.addAnalogInputChannel('Dev1', ai_channels_used, 'Voltage');
for i=1:length(ai_channels_used)
    aI(i).InputType = 'SingleEnded';
end

% Add closed loop activation output channel
s.addAnalogOutputChannel('Dev1', 3, 'Voltage');

% Add output channel for camera trigger (7)
s.addDigitalChannel('Dev1', ['port0/line7'], 'OutputOnly');


SAMPLING_RATE = 4000;
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
    scanimage_file_str = ['cdata_' trialCoreName '_dur_', num2str(run_obj.trialDuration), '_nTrials_1'];
    fprintf(scanimage_client, [scanimage_file_str]);
    disp(['Wrote: ' scanimage_file_str ' to scanimage server' ]);
    acq = fscanf(scanimage_client, '%s');
    disp(['Read acq: ' acq ' from scanimage server' ]);
end

% Delay starting the aquisition for a second to ensure that scanimage is ready
pause(1.0);

[trial_data, ~] = s.startForeground();

release(s);
end