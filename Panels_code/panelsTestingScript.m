


%% Closed loop

s = daq.createSession('ni');
s.Rate = 1000;

% Add output channel for fictive closed loop input
s.addAnalogOutputChannel('Dev1', 1, 'Voltage')

outputData = ones(s.Rate * 10, 1);
for i = 1:9
   currStartSample = 1000 * ((i - 1) + 1);
   outputData(currStartSample:currStartSample + 1000, 1) = i;
end

outputData = (1:length(outputData)) * (1 / s.Rate);

outputData(end) = 0;
queueOutputData(s, outputData');
s.startForeground();
release(s);