function setup_panels_trial(trialSettings)
%===================================================================================================
% Called from the panels_exp_GUI to start running a trial. A separate function (run_panels_trial) 
% will actually create and run the session object, then return all the recorded and output data.
%
% Input [trialSettings] is a structure containing all the necessary trial parameters (indented 
% paramters are only used if the parent parameter above them is set to true):
%
%
%     saveDir               = the parent directory to save the data in (a new folder will be created 
%                             within that directory for each experiment)
% 
%     expNum                = experiment number per date (i.e. starts at 1 each morning and 
%                             increments with each exp)
% 
%     expName               = a descriptive name for the experiment. Must be a valid file path, 
%                             since the experiment directory will contain this string (with white 
%                             space replaced with hyphens)
% 
%     trialDuration         = duration of the trial in seconds
%
%     ftConfigFile          = the full path to the desired FicTrac config file
% 
%     using2P               = boolean specifying whether to connect to scanimage
% 
%     usingPanels           = boolean specifying whether visual panels will be used
%
%          pattern          = the pattern data that will be used as the visual panels stimulus
% 
%          patternNum       = number of the pattern to give to the panels controller
% 
%          initialPosition  = the starting [X,Y] index of panels pattern to be displayed
% 
%          displayRate      = update rate of the panels
% 
%          panelsMode       = 'open loop' or 'closed loop'
%
%          xDimPosFun       = the position function vector for movement through the X dimension of the pattern
% 
%          xDimPosFunNum    = number of the X dim position function to give to the panels controller
%
%          yDimPosFun       = same, but for Y dimension
%
%          yDimPosFunNum    = same, but for Y dimension
% 
%     usingOptoStim         = boolean specifying whether a 1P opto LED stim will be used
% 
%          optoStimTiming   = timing for the opto stim in [start time, duration, ISI] format. The 
%                             stimulus LED will turn on at [start time] for [duration] seconds, and 
%                             will repeat throughout the trial with [ISI] seconds between stimuli.
% 
%          usePWM           = boolean specifying whether or not to use pulse width modulation to 
%                             attenuate the opto stim LED
% 
%              PWMPeriod    = Period (actually frequency) of the PWM cycles in Hz. Should be either 
%                             100 or 1000.
% 
%              PWMDutyCycle = Duty cycle of the PWM. For hardware reasons this must be within the 
%                             range of 2-98 if the PWMPeriod is set to 100 Hz, or 20-80 if the 
%                             PWMPeriod is 1000 Hz.
% 
%===================================================================================================

tS = trialSettings;
mD = []; mD.trialSettings = tS; % Variable for recording metadata about the trial 

% Check whether there is an existing directory with the same date and exp num
mD.expID = [datestr(now, 'yyyymmdd'), '-', num2str(tS.expNum)];
expIDDir = dir(fullfile(tS.saveDir, [mD.expID, '*']));

% If yes, make sure it also has the same experiment name and abort trial if it doesn't. 
% If no, create a new directory for the experiment.
expDirName = [mD.expID, '_', regexprep(tS.expName, '\s', '-')];
if ~isempty(expIDDir) && ~strcmp(expIDDir(1).name, expDirName)
    errordlg('Error: an experiment with the same date and number but a different name', ...
                ' already exists in the save directory...aborting trial.', 'Error')
    return
elseif ~isdir(fullfile(tS.saveDir, expDirName))
    % Create the experiment directory if it does not already exist
    mkdir(fullfile(tS.saveDir, expDirName));
    disp('Creating new experiment directory...')
end
mD.expDirName = expDirName;
mD.expDir = fullfile(tS.saveDir, expDirName);

% Copy the FicTac config file to the experiment directory if it is not already there
configFileName = regexp(tS.ftConfigFile, '(?<=\\)[^\\]*(\.txt)', 'match', 'once');
if ~exist(fullfile(mD.expDir, configFileName), 'file')
%     disp(tS.ftConfigFile)
%     disp(fullfile(mD.expDir, configFileName));
    copyfile(tS.ftConfigFile, fullfile(mD.expDir, 'config.txt'));
end

% Determine next trial number by looking at previously saved metadata files
mdFiles = dir(fullfile(mD.expDir, '*metadata*.mat'));
fileNames = {mdFiles.name};
if ~isempty(fileNames)
    regexpStr = '(?<=trial_).*(?=\.mat)';
    % Strip out the padded trial numbers from each of the the file names
    trialNums = cellfun(@regexp, fileNames, ...
            repmat({regexpStr}, 1, numel(fileNames)), ...
            repmat({'match'}, 1, numel(fileNames)), ...
            'uniformoutput', 0);
    % Find the max and add one to it to get the current trial number
    mD.trialNum = max(cellfun(@str2double, trialNums))+ 1;
else
    mD.trialNum = 1; % If no existing files, this must be the first trial
end


% Connect to scanimage if using the 2P for this experiment
if tS.using2P
    disp('Connecting to scanimage server...')
    scanimageClientSkt = tcpip('cassowary.med.harvard.edu', 30000, 'NetworkRole', 'client');
    fopen(scanimageClientSkt);
    flushinput(scanimageClientSkt);
else
    scanimageClientSkt = [];
end

% Configure panels
if tS.usingPanels
    disp('Configuring panels...')
    configure_panels(tS.patternNum, 'DisplayRate', tS.displayRate, 'InitialPos', tS.initialPosition, ...
            'PanelsMode', tS.panelsMode, 'PosFunNumX', tS.xDimPosFunNum, 'PosFunNumY', tS.yDimPosFunNum);
end


% Note: config.txt is copied in to the expt folder by the GUI when the angle is picked
% YEF, make sure this works with open and closed loop...

% Start FicTrac in background from current experiment directory (config file must be in directory)
FT_PATH = 'C:\Users\Wilson Lab\Documents\fictrac-develop\bin\Release\fictrac.exe';
cmdStr = ['cd "', mD.expDir, '" & start "" "',  FT_PATH, ...
        '" config.txt & exit'];
system(cmdStr);
pause(4);


% if recording in 'closed loop' panels mode call socket_client_360 to open socket connection from fictrac to
% Phiget22 device
if(strcmp(tS.panelsMode,'closed loop'))
    Socket_PATH = 'C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Panels_code\';
    system( ['cd ' Socket_PATH])%navigate to socket client script directory
    %system('python socket_client_360.py'); %run python socket script
    system('python socket_client_360.py &'); %run python socket script and keep console window open in background
end


% Add some hardcoded session params
mD.SAMPLING_RATE = 10000;

% Run trial
disp(['Starting trial #', num2str(mD.trialNum), ' at ', datestr(now, 'HH:MM:SS PM')])
daysPerSec = 1 * (1/24) * (1/60) * (1/60);
disp(['Trial end time: ' datestr(now + (tS.trialDuration * daysPerSec), 'HH:MM:SS PM')])
[trialData, outputData, columnLabels] = run_panels_trial(mD, scanimageClientSkt);


if(strcmp(tS.panelsMode,'closed loop'))
    system('exit'); % exit console opened for python socket
end

% Turn off panels if necessary
if tS.usingPanels
   Panel_com('stop')
   Panel_com('disable_extern_trig')
   Panel_com('all_off')
end

% Kill FicTrac execution
[~, cmdOut] = system('tasklist | findstr /i "fictrac.exe"');
cmdOut = strsplit(cmdOut);
pid = cmdOut{2};
system(['"C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\windows-kill.exe" -SIGINT ', pid]);

% Wait a sec and send another one just for good measure
pause(1)
system(['"C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\windows-kill.exe" -SIGINT ', pid]);

% Close scanimage connection
if tS.using2P
    fprintf(scanimageClientSkt, 'END_OF_SESSION');
    fclose(scanimageClientSkt);
end

% Save data, adding a precise timestamp in the middle of the file names for reference
saveFilePrefix = fullfile(mD.expDir, [mD.expID, '_']);
saveFileSuffix = ['_', datestr(now, 'HHMMSS'), '_trial_', ...
        pad(num2str(mD.trialNum), 3, 'left', '0'), '.mat']; 
% disp(saveFilePrefix)
% disp(saveFileSuffix)
save([saveFilePrefix, 'metadata', saveFileSuffix], 'mD', '-v7.3');
save([saveFilePrefix, 'daqData', saveFileSuffix], 'trialData', 'outputData', 'columnLabels', '-v7.3');


%%% ---------- PROCESS FICTRAC OUTPUT FILES ---------- %%%

% Rename the FicTrac output files that were created during this trial and then move them to a 
% dedicated subdirectory. There should be four output files from each trial: one .dat with the data, 
% one .log with the log, one .txt with the video frame log, and one .avi with the raw video.

% Pause to make sure FicTrac process has terminated
pause(5)

% Identify the new output files in the main experiment directory
ftLogFiles = dir(fullfile(mD.expDir, 'fictrac*.dat'));
ftDataFiles = dir(fullfile(mD.expDir, 'fictrac*.log'));
ftVidFiles = dir(fullfile(mD.expDir, 'fictrac*.mp4'));
ftFrameLogFiles = dir(fullfile(mD.expDir, 'fictrac-vidLogFrames*.txt'));

% If there is not exactly one of each file, abort and let the user sort it out manually.
if numel(ftLogFiles) > 1 || numel(ftDataFiles) > 1 || ... 
            numel(ftVidFiles) > 1 || numel(ftFrameLogFiles) > 1
    errordlg('Error: too many FicTrac output files in root experiment directory. No output files', ...
            ' from this trial have been moved or renamed.');
elseif numel(ftLogFiles) < 1 || numel(ftDataFiles) < 1 || ...
            numel(ftVidFiles) < 1 || numel(ftFrameLogFiles) < 1
    errordlg('Error: one or more FicTrac output files is missing from the root experiment ', ...
            'directory. No output files from this trial have been moved or renamed.');
else
    % Create new subdirectory for FicTrac data if it does not already exist
    ftDataDir = fullfile(mD.expDir, 'FicTracData');
    if ~isdir(ftDataDir)
        mkdir(ftDataDir);
    end
    
    % Append trial number onto the end of the data file names and move them to FicTracData folder
    dataFileNames = {ftLogFiles.name, ftDataFiles.name, ftVidFiles.name, ftFrameLogFiles.name};
    trialStr = pad(num2str(mD.trialNum), 3, 'left', '0');
    for iFile = 1:numel(dataFileNames)
       sourceName = fullfile(mD.expDir, dataFileNames{iFile}); 
       destName = fullfile(ftDataDir, regexprep(dataFileNames{iFile}, '\.', ['_trial_', trialStr, '.']));
       movefile(sourceName, destName);
%        disp(['Moved ', sourceName, ' to ', destName]);
    end    
end

end
