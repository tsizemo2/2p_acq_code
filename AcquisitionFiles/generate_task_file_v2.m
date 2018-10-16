function generate_task_file_v2(stimTypes, stimTimes, stimDurs, varargin)
%====================================================================================================
%
% Generates a pseudo-randomized task file for 2P experiments, allowing user to customize number of
% tasks, timing, and number of appearances of each task. The output list is saved as a .txt file,
% overwriting any previous file with that name.
%
% INPUTS:
%       stimTypes   =  Nx1 cell array containing the name of one task in each cell.
%
%       stimTimes   =  N x 1 numeric vector containing the time in seconds during the trial when
%                      each stim should be presented.
%
%       stimDurs    =  N x 1 vector specifying the duration in seconds of each stim
%
% OPTIONAL:
%
%       reps        =  Nx1 vector containing the number of times each task should appear in the file.
% 
%       savePath    =  Full path to the directory where the task file is to be saved. Can omit to
%                      generate a pop-up window to select a directory.
%
%       stimOrder   = a numeric vector specifying an order to use instead of randomizing. The numbers
%                     should refer to the order that the stimTypes are listed in.
%
%       nameStr     = if providing a stimOrder, a string to add onto the task file name for ID purposes.
%
%====================================================================================================

p = inputParser;
p.addOptional('SavePath', []);
p.addOptional('StimOrder', []);
p.addOptional('Reps', []);
p.addOptional('NameStr', '');
parse(p, varargin{:})
savePath = p.Results.SavePath;
stimOrder = p.Results.StimOrder;
reps = p.Results.Reps;
nameStr = p.Results.NameStr;

% Prompt user for save directory if none was provided
if isempty(savePath)
    savePath = uigetdir('C:\Users\wilson_lab\Desktop\Michael', 'Select a save directory');
end

% Generate list of tasks
fullTaskRep =[]; taskFileNameStr = []; taskList = cell(size(stimOrder)); 
for iTask = 1:length(stimTypes)
    fullTaskName = [stimTypes{iTask}, '_Onset_', num2str(stimTimes(iTask)), '_Dur_', num2str(stimDurs(iTask))];
    if ~isempty(stimOrder)
        
        % Use the task order that was provided
        taskList(stimOrder == iTask) = {fullTaskName};
        taskFileNameStr = [taskFileNameStr, fullTaskName, '_'];
    else
        % Randomize task order
        taskFileNameStr = [taskFileNameStr, fullTaskName, '_x', num2str(reps(iTask)), '_'];
        fullTaskRep = [fullTaskRep; repmat({fullTaskName}, reps(iTask), 1)];
    end
end

% Finish making file name
if ~isempty(stimOrder)
    taskFileNameStr = [taskFileNameStr, 'Trials_x', num2str(numel(stimOrder)), '_', nameStr];
else
    taskFileNameStr = taskFileNameStr(1:end-1); % Drop trailing underscore
end

% Randomize task list order
if isempty(stimOrder)
    % Randomize task list
    taskList = fullTaskRep(randperm(length(fullTaskRep)));
end

% Write list to file
taskFile = fopen(fullfile(savePath, [taskFileNameStr, '.txt']), 'w+');
for iTask = 1:length(taskList)
    fprintf(taskFile, '%s\r\n', taskList{iTask});
end
fclose(taskFile);

disp(['File saved as ', fullfile(savePath, [taskFileNameStr, '.txt'])])
end