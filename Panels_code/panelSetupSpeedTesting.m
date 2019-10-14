

% Set up session 
s = daq.createSession('ni');
SAMP_RATE = 2000;
s.Rate = SAMP_RATE;
s.DurationInSeconds = 30;

% Add analog input channels for reading panels status
s.addAnalogInputChannel('Dev1', 11:12, 'Voltage');

% Set up and start panels
patternNum = 1;
posFunNumX = 1;
posFunNumY = 3; % Just a static function at the starting index
ready = configure_panels(patternNum, 'PosFunNumX', posFunNumX, 'PosFunNumY', posFunNumY);

% Start acquisition
panelData = s.startForeground;
release(s);

% Turn panels off
Panel_com('stop')


% %
% 
% xData = panelData(:,1);
% % nFrames(end + 1, 1) = sum(xData(1:5000) > 0 & xData(1:5000) < 1.2);
% % nFrames(end, 2) = sum(xData > 1.5 & xData < 2.5);
% % nFrames(end, 3) = sum(xData > 2.5 & xData < 3.5);
% 
% 
% startInds(end + 1, 1) = find(xData > 1.5, 1);
% startInds(end, 2) = find(xData > 2.5, 1);
% startInds(end, 3) = find(xData > 3.5, 1)
% 
% figure(1);clf;plot(xData);
% hold on; plot(panelData(:,2));


%%

% sR = numel(xData) / numel(func)
% rsFunc = resample(func, sR:sR:numel(xData));

test = resample(xDataT, numel(func), numel(xData), 1);
figure(2);clf;hold on; plot(func); plot(test)

[r, lags] = xcorr(func, test, 1000);

