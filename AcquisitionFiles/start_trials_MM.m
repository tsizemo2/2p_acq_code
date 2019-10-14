function [ output_args ] = start_trials_MM( run_obj )


metaData = [];
STIM_TYPE = 'Task File';

if(strcmp(STIM_TYPE, 'Task File') == 1)
    
    % Read task file
    taskFilePath = run_obj.taskFilePath;
    disp(['About to start trials using task file: ' taskFilePath]);
    tasks = read_task_file(taskFilePath);
    nTasks = length(tasks); 
    
    % Connect to scanimage
    scanimage_client_skt = '';
    if run_obj.using2P
        scanimage_client_skt = connect_to_scanimage();
%         fopen(scanimage_client_skt);
        disp('Connected to scanimage server');
    end

    sid = run_obj.sid;
    run_obj.nTrials = nTasks;
       
    % Figure out what the next block number should be
    dirFiles = dir(fullfile(run_obj.expDir, ['metadata*sid_', num2str(sid), '*']));
    dirNames = {dirFiles.name};
    if ~isempty(dirNames)
        regExpStr = ['(?<=sid_', num2str(sid), '_bid_).*(?=\.mat)'];
        blockNums = cellfun(@regexp, dirNames, ...
            repmat({regExpStr}, 1, numel(dirNames)), ...
            repmat({'match'}, 1, numel(dirNames)), 'uniformoutput', 0);
        currBlock = num2str(max(cellfun(@str2double, blockNums) + 1));
    else
        currBlock = 0;
    end
    
    % Run trials
    disp(['Starting block #', num2str(currBlock), ' at ', datestr(now)])
    disp(['Running ', num2str(run_obj.nTrials), ' trials lasting ', num2str(run_obj.trialDuration), ' seconds each'])
    disp(['Block duration: ', num2str(run_obj.trialDuration * run_obj.nTrials), ' seconds']);
    daysPerSec = 1 * (1/24) * (1/60) * (1/60);
    disp(['Block end time: ', datestr(now + (run_obj.trialDuration * run_obj.nTrials * daysPerSec))])
    currBlockCoreName = [datestr(now, 'yyyymmdd_HHMMSS'), '_sid_', num2str(sid), '_bid_', num2str(currBlock)];
    allTasks = cellfun(@(x) regexprep(x, '_', '-'), tasks, 'UniformOutput', 0);
    if contains(allTasks{1}, 'Closed-Loop')
        [blockData, outputData] = run_trial_MM_CL(allTasks, run_obj, scanimage_client_skt, currBlockCoreName );
    else
        [blockData, outputData] = run_trials_MM(allTasks, run_obj, scanimage_client_skt, currBlockCoreName );
    end

    % Save fictrac data
    blockData = blockData(1:100:end, :); % downsample to reduce file size
    save([run_obj.expDir '\fictracData_' currBlockCoreName '.mat'], 'blockData', '-v7.3')
        
    % Save metadata
    metaData.nTrials = run_obj.nTrials;
    metaData.trialDuration = run_obj.trialDuration;
    metaData.stimTypes = tasks;
    metaData.sid = run_obj.sid;
    metaData.taskFile = run_obj.taskFilePath;
    metaData.outputData = outputData(1:100:end, :);
    save([run_obj.expDir '\metadata_' currBlockCoreName '.mat'], 'metaData', '-v7.3');
         
    % Close scanimage connection
    if run_obj.using2P
        fprintf(scanimage_client_skt, 'END_OF_SESSION');
        fclose(scanimage_client_skt);
    end
    disp('Trials complete.')
else
    disp(STIM_TYPE);
    disp(['ERROR: stim_type: ' STIM_TYPE ' is not supported.']);
end%if

end%function

