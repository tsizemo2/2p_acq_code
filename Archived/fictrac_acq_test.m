function fictrac_acq_test(duration)


% Setup data structures for read / write on the daq board
s = daq.createSession('ni');

% Add analog input channels for FicTrac data
ai_channels_used = [0:2];
aI = s.addAnalogInputChannel('Dev1', ai_channels_used, 'Voltage');
for i=1:length(ai_channels_used)
    aI(i).InputType = 'SingleEnded';
end

% Input channels:
%
%   Dev1:
%       AI.0 = FicTrac X
%       AI.1 = FicTrac Yaw
%       AI.2 = FicTrac Y
%

SAMPLING_RATE = 4000;
s.Rate = SAMPLING_RATE;
s.DurationInSeconds = duration;
% Delay starting the aquisition for a second to ensure that scanimage is ready
pause(1.0);

[trialData, trial_time] = s.startForeground();

release(s);

% Plot acquired data
figure(1); clf;
plot(trialData)

end