function start_panels_trial(trialSettings)
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
%     using2P               = boolean specifying whether to connect to scanimage
% 
%     usingPanels           = boolean specifying whether visual panels will be used
% 
%          patternNum       = number of the pattern to use as the visual panels stimulus
% 
%          initialPosition  = the starting [X,Y] index of panels pattern to be displayed
% 
%          displayRate      = update rate of the panels
% 
%          panelsMode       = 'open loop' or 'closed loop'
% 
%          xDimPosFun       = number of the position function for movement through the X dimension 
%                             of the pattern
%                             
%          yDimPosFun       = same, but for Y dimension
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
expIDDir = dir(fullfile(ts.saveDir, [mD.expID, '*']));

% If yes, make sure it also has the same experiment name and abort trial if it doesn't. 
% If no, create a new directory for the experiment.
expDirName = [mD.expID, '_', regexprep(tS.expName, '\s', '-')];
if ~isempty(expIDDir) && ~strcmp(expIDDir(1).name, expDirName)
    errordlg('Error: an experiment with the same date and number but a different name', ...
                ' already exists in the save directory...aborting trial.', 'Error')
    return
elseif ~isfolder(expDirName)
    % Create the experiment directory if it does not already exist
    mkdir(fullfile(tS.saveDir, expDirName));
    disp('Creating new experiment directory...')
end
mD.expDirName = expDirName;

% Determine next trial number by looking at previously saved metadata files
mdFiles = dir(fullfile(ts.SaveDir, expDirName, 'metadata*.mat'));
fileNames = {mdFiles.name};
if ~isempty(fileNames)
    regexStr = '(?<=trial_).*(?=\.mat)';
    % Strip out the padded trial numbers from each of the the file names
    trialNums = cellfun(@regexp, fileNames, ...
            repmat({regexpStr}, 1, numel(fileNames)), ...
            repmat({'match'}, 1, numel(dirNames)), ...
            'uniformoutput', 0);
    % Find the max and add one to it to get the current trial number
    mD.trialNum = max(cellfun(@str2double, trialNums), + 1);
else
    mD.trialNum = 1; % If no existing files, this must be the first trial
end




% Connect to scanimage if using the 2P for this experiment
if tS.using2P
    disp('Connecting to scanimage server...')
    scanimageClientSkt = tcpip('cassowary.med.harvard.edu', 30000, 'NetworkRole', 'client');
    flushinput(scanimageClientSkt);
else
    scanimageClientSkt = [];
end

% Configure panels
if tS.usingPanels
    disp('Configuring panels...')
    configure_panels(tS.patternNum, 'DisplayRate', tS.displayRate, 'InitialPos', tS.initialPos, ...
            'PanelMode', tS.panelMode, 'PosFunNumX', ts.xDimPosFun, 'PosFunNumY', ts.yDimPosFun);
end

% TODO: make changes to FicTrac configuration?

% Add some hardcoded session params
mD.SAMPLING_RATE = 10000;

% Run trial
[trialData, outputData, columnLabels] = run_panels_exp(mD, scanimageClientSkt);

% Turn off panels if necessary
if tS.usingPanels
   Panel_com('stop')
   Panel_com('all off')
%    Panel_com('disable_extern_trig')
end

% Close scanimage connection
if tS.using2P
    fprintf(scanimageClientSkt, 'END_OF_SESSION');
    fclose(scanimageClientSkt);
end

% Save data, adding a precise timestamp in the middle of the file names for reference
saveFilePrefix = fullfile(tS.saveDir, [mD.expID, '_']);
saveFileSuffix = ['_', datestr(now, 'HHMMSS'), '_trial_', ...
        pad(num2str(mD.trialNum), 3, 'left', '0'), '.mat']; 
save([saveFilePrefix, 'metadata', saveFileSuffix], mD, '-v7.3');
save([saveFilePrefix, 'daqData', saveFileSuffix], trialData, outputData, columnLabels, '-v7.3');


end