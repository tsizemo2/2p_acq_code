function flush_olfactometer(duration)
% Flushes olfactometer out for a period specificed by "duration". Opens 
% valve A for the first half of the period and valve B for the second half.
% 
% duration = total time in minutes for the flushing process to last
% 

global s
% Setup data structures for read / write on the daq board
s = daq.createSession('ni');

% Add output channels
s.addAnalogOutputChannel('Dev1', 0, 'Voltage');
s.addDigitalChannel('Dev1', ['port0/line1:3'], 'OutputOnly');

% Output channels:
%   Dev3:
%       AO.1        = dummy channel just to use clock
%       P0.1        = olfactometer valve A/shutoff B
%       P0.2        = olfactometer valve B/shutoff A
%       P0.3        = olfactometer NO valve ("dummy") 

SAMPLING_RATE = 1000;
s.Rate = SAMPLING_RATE;
chanSecDur = round(duration * 60 / 2);
chanSampDur = round(chanSecDur * SAMPLING_RATE);

% Initialize the output vectors to zero
zeroStim = zeros(chanSampDur * 2, 1);
chanACommand = zeroStim;
chanBCommand = zeroStim;
dummyCommand = zeroStim;

% Create stim output vectors
chanACommand(1:chanSampDur) = 1;
chanBCommand(chanSampDur:end) = 1;
dummyCommand(:) = 1;

outputData = [zeroStim, chanACommand, chanBCommand, dummyCommand];
outputData(end, :) = 0; % To make sure the DAQ doesn't stay on between trials
queueOutputData(s, outputData);

s.startForeground();
release(s);

end