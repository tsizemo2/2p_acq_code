

% Set up session 
s = daq.createSession('ni');
SAMP_RATE = 2000;
s.Rate = SAMP_RATE;
s.DurationInSeconds = 10;

% Add analog input channels for reading panels status
s.addAnalogInputChannel('Dev1', , 'Voltage');

% Set up and start panels
patternNum = 1;
posFunNumX = 4;
posFunNumY = 3; % Just a static function at the starting index
ready = configure_panels(patternNum, 'PosFunNumX', posFunNumX, 'PosFunNumY', posFunNumY);

% Start acquisition
panelData = s.startForeground;
release(s);


