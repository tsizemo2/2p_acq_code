function [] = fly_tracker_server_v2()
% fly_tracker_server Summary of this function goes here

% example for using the ScanImage API to set up a grab
hSI = evalin('base','hSI');             % get hSI from the base workspace

%%%%
% Start a server to listen on the socket to fly tracker
%%%%
clear t;
PORT = 30000;
t = tcpip('0.0.0.0', PORT, 'NetworkRole', 'server');
set(t, 'InputBufferSize', 30000); 
set(t, 'TransferDelay', 'off');
disp(['About to listen on port: ' num2str(PORT)]);
fopen(t);
pause(1.0);
disp('Client connected');

% % Set session parameters
% while (t.BytesAvailable == 0)
%     pause(0.1);
% end
%        
% trial_time_str = fscanf(t,'%s');
% disp(['Trial time str: ' trial_time_str ]);
% 
% tt = strsplit(trial_time_str, '=');
% trial_time = str2num( tt{ 2 } );
% 
% disp(['Trial time: ' num2str(trial_time)]);
% 
% % Set volumes to scan
% volumes_per_second = hSI.hRoiManager.scanVolumeRate;
% disp(['VPS: ' num2str( volumes_per_second )]);
% 
% hSI.hFastZ.numVolumes = int32(ceil( trial_time * volumes_per_second ));
% disp(['Number of volumes: ' num2str( hSI.hFastZ.numVolumes )]);
% 
% fprintf(t, 'SI51_Acq_0');

nTrials = 1; % default
while 1
    
    % Read the message     
    while (t.BytesAvailable == 0)
        pause(0.1);
    end
        
    data = fscanf(t, '%s');
    data = strtrim(data);
    disp(data);
    
    % See if string is specifying info or giving acquisition command
    if regexp(data, 'nTrials: ') % check for nTrials
        nTrialsStr = regexp(data, '(?<=nTrials: ).*', 'match');
        nTrials = str2double(nTrialsStr{:});
    elseif regexp(data, 'trialDuration: ') % Check for trial duration
        trialDurStr = regexp(data, '(?<=trialDuration: ).*', 'match');
        single_trial_time = str2double(trialDurStr{:});
    elseif( strcmp(data,'END_OF_SESSION') == 1 ) % Check for end of session
        break;
    else
        
        % Set up scanimage
        volumes_per_second = hSI.hRoiManager.scanVolumeRate;
        disp(['VPS: ' num2str( volumes_per_second )]);
        hSI.hScan2D.logFileStem = data;      % set the base file name for the Tiff file
        hSI.hChannels.loggingEnable = true;     % enable logging
        hSI.extTrigEnable = true;               % Enable external trigger, the external trigger button should turn green.
        
        % Set total number of volumes in block
        hSI.hFastZ.numVolumes = int32(ceil( single_trial_time * nTrials * volumes_per_second ));
        disp(['Number of volumes: ' num2str( hSI.hFastZ.numVolumes )]);
        
        % Save each trial as a different file
        hSI.hScan2D.logFramesPerFile = (hSI.hFastZ.numVolumes / nTrials) * hSI.hFastZ.numFramesPerVolume;
        
        % Start acquisition
        pause(1.0);
        hSI.startGrab();                   
        
        % Signal back to the fly tracker client that it can start daq and image
        % acquisition.
        fprintf(t, 'SI51_Acq_1');
    end
end

% Clean up
hSI.extTrigEnable = false;         

%close the socket
fclose(t);
delete(t);

end