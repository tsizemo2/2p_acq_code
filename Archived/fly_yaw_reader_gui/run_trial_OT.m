function [ trial_data, trial_time ] = run_trial_OT( trial_idx, task, run_obj, scanimage_client, trial_core_name )

disp(['About to start trial task: ' task]);

% Setup data structures for read / write on the daq board
s = daq.createSession('ni');

disp(['Got here 21']);

% This channel is for external triggering of scanimage 5.1
s.addDigitalChannel('Dev1', 'port0/line0', 'OutputOnly'); % Start trigger
s.addDigitalChannel('Dev1', 'port0/line6', 'OutputOnly'); % Stop trigger

disp(['Got here 20']);

if( strcmp(task, 'PicoPump') == 1 )
    s.addDigitalChannel('Dev1', 'port0/line5', 'OutputOnly'); % Pico pump trigger
end

% These are for inputs: motion sensor 1 x,y; motion sensor 2 x,y; frame
% clock; stim left; stim right;
ai_channels_used = [0:6];
aI = s.addAnalogInputChannel('Dev1', ai_channels_used, 'Voltage');
for i=1:length(ai_channels_used)
    aI(i).InputType = 'SingleEnded';
end

disp(['Got here 22']);

% This is the stim control: stim left, stim right
s.addAnalogOutputChannel('Dev1', 0:1, 'Voltage');

% This is the 2p aquisition stop trigger.
%s.addDigitalChannel('Dev1', 'port0/line6', 'OutputOnly');
disp(['Got here 2']);

settings = sensor_settings;

SAMPLING_RATE = settings.sampRate;
s.Rate = SAMPLING_RATE;
total_duration = run_obj.pre_stim_t + run_obj.stim_t + run_obj.post_stim_t;
%s.DurationInSeconds = total_duration;

zero_stim = zeros(SAMPLING_RATE*total_duration,1);
stim = zeros(SAMPLING_RATE*total_duration,1);
pico_stim = zeros(SAMPLING_RATE*total_duration,1);

begin_idx = run_obj.pre_stim_t * SAMPLING_RATE;
end_idx = (run_obj.pre_stim_t+run_obj.stim_t) * SAMPLING_RATE;
stim(begin_idx:end_idx) = 5.0;
pico_stim(begin_idx:end_idx) = 1.0;

imaging_start_trigger = zero_stim;
imaging_stop_trigger = zero_stim;

% WARNING: THIS IS A TEST FOR 2p activation during volumetric imaging
imaging_start_trigger(2:end-1) = 1.0;

% %%%%%%%%% old version
% % generate LED pulse during flyback frames
% ClockOn = 2.77; % [samples] for 4kHz sampling
% ClockInt = 38.82; % [samples]
% N_volume = run_obj.N_volume;
% N_flyback = run_obj.N_flyback;
% 
% stim_LED = zeros(SAMPLING_RATE*total_duration,1);
% 
% Counter = 1;
% VolumeOff = 0;
% while VolumeOff<total_duration*SAMPLING_RATE
%     VolumeOn = ClockOn + ClockInt*N_volume*(Counter-1);
%     Flybackoff = VolumeOn + N_flyback*ClockInt;
%     VolumeOff = VolumeOn + (N_volume-1)*ClockInt;
%     if begin_idx<VolumeOn && Flybackoff<end_idx
%         stim_LED(round(VolumeOn):round(Flybackoff)) = 5.0; % analog output
%     end
%     Counter = Counter+1;
% end

%%%%%%%%%%%% generate LED pulse during flyback frames
% get parameters from the GUI
N_volume = run_obj.N_volume;
N_flyback = run_obj.N_flyback;
FrameRate = run_obj.FrameRate;

disp(['Got here 3']);

%
%ClockOnLatency = 2.77; % for 103.04 Hz [samples] % empirically measured, need to change if Fs changes!
ClockOnLatency = 1.62; % for 176.21

T = 1/FrameRate; % [s] period of the frame clock
ClockPeriod = SAMPLING_RATE*T; % [samples]

stim_LED = zeros(SAMPLING_RATE*total_duration,1); % initialize

Counter = 1; % initialize counter
VolumeEnd = 0; % initialize so that it can pass the first while loop
while VolumeEnd<total_duration*SAMPLING_RATE
    VolumeStart = ClockOnLatency + ClockPeriod*N_volume*(Counter-1); % start of every volume [samples]
    FlybackStart = VolumeStart; % flyback starts at the onset of volume [samples]
    FlybackEnd = VolumeStart + N_flyback*ClockPeriod; % flyback during the first N_flyback frames per volume [samples]
    VolumeEnd = VolumeStart + (N_volume-1)*ClockPeriod; % end of each volume [samples]
    if begin_idx<FlybackStart && FlybackEnd<end_idx % if the current flyback is within the specified stimulus interval
        stim_LED(round(FlybackStart):round(FlybackEnd)) = 5.0; % analog output is high only during flyback
    end
    Counter = Counter+1; % go to the next volume
end
% %%%%%%%%%%%%

disp(['Got here 4']);

output_data = [];
if( strcmp(task, '2pStim') == 1 )
    imaging_start_trigger = zero_stim;
    imaging_stop_trigger = zero_stim;
    imaging_start_trigger(begin_idx) = 1.0;
    imaging_stop_trigger(end_idx) = 1.0;

    output_data = [imaging_start_trigger imaging_stop_trigger zero_stim zero_stim ];
    total_duration = run_obj.stim_t;
elseif( strcmp(task, 'PicoPump') == 1 )
    output_data = [imaging_start_trigger imaging_stop_trigger pico_stim zero_stim zero_stim ];
elseif( strcmp(task, 'LeftOdor') == 1 )
    output_data = [imaging_start_trigger imaging_stop_trigger stim_LED zero_stim ];
elseif( strcmp(task, 'RightOdor') == 1 )
    output_data = [imaging_start_trigger imaging_stop_trigger zero_stim stim_LED ];
elseif( strcmp(task, 'BothOdor') == 1 )
    output_data = [imaging_start_trigger imaging_stop_trigger stim_LED stim_LED ];
elseif( strcmp(task, 'NaturalOdor') == 1 )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This is where olfactometer stim parameters are defined.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    PINCH_VALVE_OPEN_TIME = 1.0;
    begin_idx = PINCH_VALVE_OPEN_TIME * SAMPLING_RATE;
    
    pinch_valve_waveform = zeros(SAMPLING_RATE*total_duration,1);
    pinch_valve_waveform( begin_idx:end-1 ) = 5.0; % volts
    
    output_data = [imaging_start_trigger imaging_stop_trigger pinch_valve_waveform stim ];
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
elseif( strncmpi(task, 'sound', 5) == 1 )  %the relevant line in the txt task file needs to start with "sound"
    % here several entries in the GUI will be ignored (prestim, stim, poststim)
    fs = 40000;

    add_s_on = 9; % extra time added (beyond 1 s) before stimulus onset (in seconds); if this value = 1 the stimulus starts at 80000 samples so time = 2 sec
    add_s_off = 10; % time added after stimulus offset (in seconds)
    intensity = 2; % output voltage (in V)
 
    stim = audioread(['C:\Users\wilson_lab\Desktop\Rachel\auditory_stim_files\' task '.wav']); % load stimulus (the relevant line in the txt task file must be identical to the name of the wav file)
    stim = intensity/max(abs(stim))*stim;
    stim = [zeros(1,add_s_on*fs) stim' zeros(1,add_s_off*fs)];
    
    zero_stim = zeros(size(stim,2),1);    
    
    imaging_trigger = zero_stim;
    imaging_trigger(2:end-1) = 1.0;

    % Setup data structures for read / write on the daq board
    s.Rate = fs;
    
    total_duration = size( stim, 2 ) / fs;
    
    output_data = [imaging_start_trigger imaging_stop_trigger zero_stim stim' ];
else
    disp(['ERROR: Task: ' task ' is not recognized.']);
end

queueOutputData(s, output_data);

disp(['Got here 1']);

% Trigger scanimage run if using 2p.
if(run_obj.using_2p == 1)
    scanimage_file_str = ['cdata_' trial_core_name '_tt_' num2str(total_duration) '_'];
    fprintf(scanimage_client, [scanimage_file_str]);
    disp(['Wrote: ' scanimage_file_str ' to scanimage server' ]);
    acq = fscanf(scanimage_client, '%s');
    disp(['Read acq: ' acq ' from scanimage server' ]);    
end

% Delay starting the aquisition for a second to ensure that scanimage is
% ready
pause(1.0);

[trial_data, trial_time] = s.startForeground();

release(s);
end

